## 20241030 Fantastic Genomic Biomarkers and Where to Find Them Practical Course (part VII)



## Main Content of the Course

####  <span style="color: red;">Today's class will be a review and summary of the content from the past eight weeks, using the data this week as an example.</span>
    
The workflow for NGS data analysis is as follows:
![截圖 2024-10-28 晚上11.08.04](https://hackmd.io/_uploads/S1EgYXpgyx.png)

The steps for analyzing NGS data after acquisition are as follows:

1. After obtaining the NGS data, it is essential to ensure that the data has sufficient quality for analysis to ensure the accuracy of the final results. Therefore, we need to perform **FastQC** first.

2. The raw data from NGS consists of short fragments, which can be classified into short reads and long reads. Regardless of the type, they must be compared with the reference genome. This process is akin to assembling a puzzle, where we align the fragments (or reads) from the raw data back to their correct positions in the genome, which is what we call **alignment**.

3. During NGS, adaptors randomly bind to both ends of the original DNA fragments and then amplify to produce new strands of DNA. However, because this process is random, it may lead to repeated attachments on previously sequenced DNA, resulting in certain fragments appearing with particularly high frequency. To avoid misleading interpretations of the depth of this sequence during analysis, we use a method called **marking duplicates** to eliminate the continuously repeated identical sequences.

4. After obtaining the correct depth and quality, we can begin our analysis with **variant calling**. As the name suggests, variant calling is the process of identifying positions in the data sequence that have variants, such as indels and SNVs. The tool we used in class for variant calling is GATK.

5. Once we have the variant information, we can compare it with various databases (such as the Taiwan Biobank database) to determine whether these variants have been reported before and whether they have clinical significance. This process is known as **annotation**.

#### Therefore, the overall steps are summarized as follows:
    NGS raw data --> fastqc --> alignment --> Mark duplicates --> variant calling --> annotation
----------------------
#### With the background knowledge provided, you can now begin writing shell scripts.

You can think of a shell script as a bread machine. When you give it different types of dough and set it to various modes, it will bake different kinds of bread. Similarly, when you input a file into a shell script, it will produce different output files based on the specific script used.

A shell script is a mini program where we can write each step as an individual script. Of course, we can also combine all the steps into a single shell script.

Next, we will introduce the content of each part of the shell script in segments. However, before we start writing the scripts, there are a few key concepts that you need to understand:

1. In the NCHC interface, there are a few important things to know: the location of the files and their names. This is similar to needing a name and an address when sending a package. This aspect is crucial because when your shell script needs to use files, you must provide the correct path so it can locate them.

    - `pwd`: Used to check the current folder location.
    - `ls`: Used to display all files in the current folder.
    - `cd`: Used to navigate to the desired folder.
    - `mkdir`: Used to create a new folder.

2. Opening a Shell Script: The text editor we frequently use in class is `vim`, which is one of many editors available. Its function is to allow you to open files and edit their content.

3. Execution Order: Shell scripts execute line by line, meaning there is a specific order of operations. Commands are executed from the top down. This is important because when defining paths or using modules, you need to ensure that prerequisites are set before executing commands.

4. Editing in Shell Script: To enter editing mode in `vim`, press the `i` key. Once in editing mode, you will see `----insert-----` at the bottom of the shell script. To exit editing mode, press the `Esc` key. After leaving editing mode, if you want to save your commands, you can type `:w` to save, `:q` to quit (and `:q!` to force quit without saving). To save and exit simultaneously, type `:wq`.

5. In shell scripts, there are several helpful tools that can make your work more convenient. Note that these tools are used in non-editing mode, so the commands you input will appear in the bottom left corner of the window:

- `/set number` + Enter : This command will display line numbers at the beginning of each line, making it easier to read.
- `/key_word` + Enter : Replace key_word with the text you want to search for. This will help you find that word throughout the entire shell script.
6. Shell script files typically have a ".sh" extension.

7. Additionally, to help us understand where the program is at or identify which part has an error, we often add `echo "start"` before a block of commands we want to execute. This informs you when the program reaches that segment. We also add `echo "Finished"` after the block to indicate its completion. These messages will then be displayed in your log file.

-----------------
### This concludes the background information. Next, we will move on to the practical operations.

### Step 1: Upload Files to Your NCHC Account

#### 1. Please go to [ntu cool](https://cool.ntu.edu.tw/courses/42564) and download two fastq files and two sh files from Week 9. The fastq files contain the raw data for this practical exercise.

#### 2. Upload the files to your NCHC account. 
Before uploading the files, navigate to the folder on your local machine where you just downloaded them (meaning, you should go to the location of the downloaded files in your terminal before logging into NCHC). Additionally, decide where you want to store the files on the NCHC system. It is recommended to log into NCHC in another terminal. You can use `pwd` to check the current path, and if necessary, you can create the required folder using `mkdir`.

Linux Operating System:
```
rsync -avz file_name username@t3-c4.nchc.org.tw:destination_dir

# rsync: A highly efficient data synchronization and transfer tool, suitable for syncing files or directories between local and remote systems or between two servers.
# -a: Archive mode, which synchronizes all files and directories, including subdirectories, while preserving the original file permissions, timestamps, and symbolic links.
# -v: Verbose mode, which displays detailed information during the synchronization process, allowing you to see the list of transferred files and progress.
# -z: Compresses the data to reduce the amount of data transferred, improving synchronization speed, especially useful over slower network connections.
```

Windows Operating System:
```
sftp username@t3-c4.nchc.org.tw
put example_file /directory/

# sftp: Stands for Secure File Transfer Protocol, which uses SSH to securely transfer files.
# put: Uploads a local file to the remote server.

```

### Step 2: Modify the Shell Script
#### Before proceeding with this step, it’s important to understand your current location and the locations of the various files you will be using.
#### 1. Open the SH file
```
vim file_name.sh  

# vim is a text editor that helps you edit SH files.
# file_name.sh is the name of your shell script file.
```
#### 2. After opening the file, you will see the following screen:
![截圖 2024-10-29 下午2.13.02](https://hackmd.io/_uploads/Hyg_aeAg1e.png)

    
```
#!/usr/bin/sh
#SBATCH -A ACD113120          # Project name: The project number for our class.
#SBATCH -J fastqc             # Job name: You can change this to any name you prefer.
#SBATCH -p ngscourse          # Partition Name
#SBATCH -c 2                  # Number of CPU cores
#SBATCH --mem=13g             # Memory allocation
#SBATCH -o tutorial.out.log   # -o: This exports the out.log file, which will record the steps executed by the program.
#SBATCH -e tutorial.err.log   # -e: This exports the err.log file, which will record any failures; if not specified otherwise, both log files will be located in the current directory of the SH file.
#SBATCH --mail-user=          # Here, you can input your email. An email will be sent to you if the next line's conditions are met.
#SBATCH --mail-type=END       # Email will be sent when the job ends.
```
#### 3. Record the Start of the Job 
![截圖 2024-10-24 下午4.07.16](https://hackmd.io/_uploads/H19BeFveJx.png)
:::success
#### Command Introduction
1. `set -v -x`: set is a built-in shell command used to set or modify parameters in the shell environment. `-v` stands for verbose mode, while `-x` indicates that the results of executed commands should be displayed. This command helps you understand the progress and errors while executing the script, and this information will be shown in the err.log file. However, if you feel this is unnecessary, you can remove this line.
2. `echo " "`: echo means to output a message, and the content within the quotes (" ") is what will be displayed.
:::

- `echo "start"`: This command outputs "start", indicating that the analysis has begun. It helps us understand that the current phase of progress has been completed.
- `echo "$(date '+%Y-%m-%d %H:%M:%S')"`: This command outputs the current date and time in the format of year-month-day and time.

#### 4. Define the Data Path and File Names
In your shell script, you should define the paths to your data and the names of the files you will be using. You can do this by setting variables like so:   
![截圖 2024-10-24 下午4.07.59](https://hackmd.io/_uploads/ByU_lKvx1x.png)

:::success
#### Command Introduction
1. `A=b`: In this context, it means assignment; that is, we are assigning the value b to the variable A. After this assignment, whenever you reference A, it will automatically take on the value of b.
2. `${}`: This is mainly used to embed the value of a variable into a string, where $ indicates that it is a variable.    
:::

- `R1=` `R2=`: Defines the names for R1 and R2.
- `fastqdir`: Defines the location of the FASTQ files.
- `R1_file=` `R2_file=`: Defines the correct paths for R1_file and R2_file.
- `echo "R1_file directory: " ${fastqdir}/${R1_file}`: Outputs the path of R1_file, helping you verify whether the path has been set correctly. 

#### 5. Create a Directory to Store FastQC Files and Execute FastQC

![截圖 2024-10-24 下午4.09.01](https://hackmd.io/_uploads/rk42gKDxkl.png)

:::success
#### Command Introduction
1. `cd`: Change directory to enter a folder.
2. `mkdir`: Create a new directory.
3. `pwd`: Display the current working directory.
4. `fastqc ${file_1} ${file_2} -o ${directory}`: This is the command for FastQC, using file_1 and file_2 as input files. After running FastQC, the output files will be directed to the specified `${directory}`. The `-o` flag indicates the output location.
:::

* ```cd ${fastqdir}```: Change to the directory specified by ${fastqdir}.
* ```mkdir fastqc_tutorial```： Create a new directory named fastqc_tutorial.
* ```cd fastqc_tutorial```： Change to the newly created fastqc_tutorial directory.
* ```module load```： Load the built-in module for FastQC available on the platform.

#### 6. Define Paths for Subsequent Analyses and the Location of the Reference Genome

![截圖 2024-10-24 下午4.10.26](https://hackmd.io/_uploads/BkC-ZYwl1x.png)

- `ref=...`： Defines the location of the reference genome.
- `sampleR1=${fastqdir}/${R1}.fastq`： Defines the location of sampleR1.
- `echo "sampleR1: " ${sampleR1}`: Outputs the location of sampleR1, helping you verify whether it is set correctly.
- `cd ${fastqdir}`： Change to the directory specified by fastqdir.
- `mkdir -p ./tutorial`： Creates a directory named tutorial in the current directory (./). The `-p` flag stands for "parents," which means that if any parent directories in the specified path do not exist, they will be created without displaying an error message. Even if the directory already exists, no error will be shown.
- `cd tutorial`： Change to the tutorial directory.
- `echo "pwd for analysis: " pwd`: Displays the current working directory.

#### 7. Start Data Analysis
![截圖 2024-10-24 下午4.12.15](https://hackmd.io/_uploads/Byq_-tPxyg.png)

:::success
#### Command Introduction
1. ```set -euo pipefail```：
- `-e`: If any command fails, the script will immediately exit to prevent further execution, which could lead to subsequent errors.
- `-u`: If the script uses an undefined variable, it will throw an error and exit. This helps check whether variables are correctly defined, avoiding unexpected errors.
- `-o` pipefail: If any command in a pipeline fails, the entire pipeline is considered to have failed.

:::

- `echo`： This command is used to notify us of the start of the entire analysis process and record the time.
- `module load`： Loads pre-installed modules (biology, BWA, SAMTOOLS) available on the NCHC.
- `set -euo pipefail`: If an error occurs in the script, it will stop immediately, preventing continued execution that could lead to incorrect results.


#### 8. DNA Alignment: BWA Mapping
In this step, we use the tool BWA (Burrows-Wheeler Aligner) to perform the DNA alignment.

![截圖 2024-10-24 下午4.13.11](https://hackmd.io/_uploads/r1z2WtDeye.png)

:::success
#### Command Introduction
```bwa mem -M -R "@RG\tID:GP_${sample}\tSM:SM_${sample}\tPL:ILLUMINA" -t 40 -K 1000000 ${ref} ${sampleR1} ${sampleR2} > ${sample}.sam```: This is the command to execute BWA for alignment.
* ```bwa mem```: Uses the mem mode of BWA for alignment, which is optimal for reads longer than 70 bp and commonly used for paired-end sequencing data.
* ```-M```: Marks duplicate sequences, which will be helpful later for marking duplicates.
* ```-R```: Specifies the read group information.
* ```@RG```: Designates the start of the read group line.
* ```ID:GP_${sample}```: Defines the ID for the reads group, here as GP_${sample}.
* ```SM: SM_${sample}```: Indicates the sample name, here as SM_${sample}.
* ```PL:ILLUMINA```: Indicates the sequencing platform used, in this case, ILLUMINA.
* ```-t 40```: Specifies the number of threads (40 in this case) to increase the alignment speed.
* ```-K 1000000```: Sets the buffer size to reduce memory usage.
* ```${ref}```: Refers to the reference genome file.
* ```${sampleR1}, ${sampleR2}```: Input data files for paired-end reads.
* ```>```: Redirects the output to a file.
* ```${sample}.sam```: Specifies the output file for storing alignment results.
:::

* ```echo...```: This command is used to notify the start and end of the BWA mapping process and to log the timestamp.
* ```bwa...```: Executes the BWA mapping.


#### 9. Convert SAM file to BAM file using SAMTOOLS

![截圖 2024-10-24 下午4.13.53](https://hackmd.io/_uploads/r16RbtDxkx.png)

:::success
#### Command Introduction
1. ```samtools view -@ 2 -S -b ${sample}.sam > ${sample}.bam```：This is a SAMTOOLS command.
* ```-@ 2```: Specifies the number of threads to use.
* ```-S```: Specifies that the input file format is SAM.
* ```-b```: Specifies that the output file format should be BAM.
* ```${sample}.sam```: Input data file.
* ```${sample}.bam```: Output data file.
2. ```samtools sort -@ 2 ${sample}.bam -o ${sample}.sorted.bam```：This is a SAMTOOLS command.
* ```samtools sort```: Sorts the BAM file by chromosome.
* ```-@ 2```: Specifies the number of threads to use.
* ```${sample}.bam```: Input data file.
* ```-o ${sample}.sorted.bam```: Specifies the sorted BAM file as output.
3. ```samtools index -@ 20 ${sample}.sorted.bam```：This is a SAMTOOLS command.
* ```samtools index```: Creates an index for the BAM file.
* ```-@ 20```: Specifies the number of threads to use.
* ```${sample}.sorted.bam```: Input data file.
:::

#### 10. Mark duplicates
![截圖 2024-10-24 下午4.14.30](https://hackmd.io/_uploads/B1m-MKvxJg.png)

:::success
#### Command Introduction
1. ```java -jar ${PICARD} MarkDuplicates -I ${sample}.sorted.bam -O ${sample}.sorted.markdup.bam -M ${sample}_markdup_metrics.txt --CREATE_INDEX true```This is a Picard command.

* ```java -jar ${PICARD}```: Executes the Picard tool’s JAR file with Java.
* ```MarkDuplicates```: A Picard module that marks duplicate reads in BAM files.
* ```-I ${sample}.sorted.bam```: Specifies the input data file.
* ```-O ${sample}.sorted.markdup.bam```: Specifies the output data file.
* ```-M ${sample}_markdup_metrics.txt```: Saves the summary statistics of duplicate reads into the file ${sample}_markdup_metrics.txt.
* ```--CREATE_INDEX true```: Automatically generates a BAM file index.

:::

* ```echo```: Notifies us of the start and end of the Picard mark duplicates process and records the time.
* ```PICARD=...```: Specifies the path and version of Picard.
*```java ...```: Executes the MarkDuplicates process.

#### 11. Using GATK HaplotypeCaller for Variant Calling
![截圖 2024-10-24 下午4.15.27](https://hackmd.io/_uploads/SyOEfKPlJx.png)

:::success
#### Command Introduction
1.```gatk HaplotypeCaller \
  -R /opt/ohpc/Taiwania3/pkg/biology/reference/Homo_sapiens/GATK/hg38/Homo_sapiens_assembly38.fasta \
  -I ${sample}.sorted.markdup.bam \
  -O ${sample}.sorted.markdup.hc.vcf.gz \
  -L chr1 -L chr2 -L chr3 -L chr4 -L chr5 -L chr6 -L chr7 -L chr8 -L chr9  \
  -L chr10 -L chr11 -L chr12 -L chr13 -L chr14 -L chr15 -L chr16 -L chr17  \
  -L chr18 -L chr19 -L chr20 -L chr21 -L chr22```:This is a GATK command.
* ```echo```: Notifies us that the GATK calling variants process has started and ended, along with time logging.
* ```module load```: Loads the built-in modules from the National Center for High-Performance Computing (Anaconda, GATK).
* ```gatk HaplotypeCaller...```: Executes the variant calling process.
:::



#### 12. Split multiallelic
![截圖 2024-10-29 下午2.18.21](https://hackmd.io/_uploads/ry9ZJWRgye.png)



:::success
#### Command Introduction
1. ```${BCFTOOLS} norm -m -any ${sample}.sorted.markdup.hc.vcf.gz -Oz -o ${sample}.sorted.markdup.hc.normed.vcf.gz```: This is a BCFTOOLS command.
* ```${BCFTOOLS} norm```: Uses the norm command from BCFTOOLS to standardize the VCF file.
* ```-m -any```: Splits multiple alleles into single alleles to ensure each line contains only one allele, which simplifies analysis.
* ```${sample}.sorted.markdup.hc.vcf.gz```: Input data.
* ```-Oz```: Compresses the output data into BGZF format.
* ```-o ${sample}.sorted.markdup.hc.normed.vcf.gz```: Output data.
:::

* ```echo```: Notifies us that BCFTOOLS is starting and finishing the split multiallelic process, along with time logging.
* ```${BCFTOOLS}...```: Executes the split multiallelic command from BCFTOOLS.

#### 13. Define the paths and modules needed for subsequent steps.

![截圖 2024-10-29 下午2.20.49](https://hackmd.io/_uploads/S1QkyZRgkg.png)


:::success
#### Command Introduction
1. ```export PATH=${PATH}:...```: This command adds a new path to the environment variable PATH, allowing executables in the specified directory to be run directly within the current script. This means you won't have to input the full path when executing commands, and it will not affect the original PATH.
:::

#### 14. Use VEP for annotation
![截圖 2024-10-28 晚上10.51.58](https://hackmd.io/_uploads/Sk07B7axkg.png)
![截圖 2024-10-24 下午4.17.24](https://hackmd.io/_uploads/HJOsGFDxke.png)

:::success
#### Command Introduction
1.```${VEP_PATH} --cache --offline \
--cache_version 108 --dir_cache ${VEP_CACHE_DIR} \
--assembly GRCh38 \
--fasta ${VEP_FASTA} \
--fork 4 \
-i ${INPUT_VCF} \
--check_existing \
--af_gnomade \
--af_gnomadg \
--vcf \
-o ${SAMPLE_ID}.vcf \
--force_overwrite```： This is a VEP command.
* ```--cache```: Use cached annotation data (no need for remote connection).
* ```--offline```: Offline mode.
* ```--cache_version 108```: Use version 108 of the cached data.
* ```--dir_cache ${VEP_CACHE_DIR}```: Specify the directory for the cache.
* ```--assembly GRCh38```: Use the GRCh38 reference genome for annotation.
* ```--fasta ${VEP_FASTA}```: Use the FASTA file of the GRCh38 reference.
* ```--fork 4```: Specify the number of threads.
* ```-i ${INPUT_VCF}```: Input data.
* ```--check_existing```: Check if variants exist in the database.
* ```--af_gnomad``` and ```--af_gnomadg```: Include allele frequency information from the gnomAD database (for both exome and genome).
* ```--vcf```: Output data format is VCF.
* ```-o ${SAMPLE_ID}.vcf```: Output data.
* ```--force_overwrite```: Overwrite existing duplicate files (to save space).

:::
* ```echo```: Notifies us that the VEP annotation has started and ends, along with time recording.
* ```${VEP_PATH}...```: Executes the annotation.
---------------------------
### Practice
change the variant calling method from GATK HaplotypeCaller to GATK Mutect2.

1. First, create a copy of `tutorial.sh` and name it `tutorial_mutect2.sh`:
```
cp tutorial.sh tutorial_mutect2.sh
```
Then.

2. Open `Mutect2.sh`, copy its contents, and replace the variant calling section in `tutorial_mutect2.sh` with this content.

3. Edit parameters in `tutorial_mutect2.sh` as follows:
**Hint~Required Modifications at:**
(1) File names for `err.log` and `out.log` at the beginning of the script.
(2) Output file name for variant calling.
(3) Any file names that change due to the new variant calling output file name.
<span style="color: red;">Note: Ensure all necessary modifications are made. If the output file names are not fully updated, they may overlap with files from the previous HaplotypeCaller process and overwrite those files. <span>

4. Execute the modified shell script.


------------------------------------
# 生物標記物與它們的產地實作課程(七)
## 本次課程主要內容
    
#### <span style="color: red;">今日課程為將過去八週課程內容統整及複習，以本週課程的 data 為例 </span>

NGS data analysis流程如下：
![截圖 2024-10-28 晚上11.08.04](https://hackmd.io/_uploads/S1EgYXpgyx.png)

以下是拿到 NGS data 後分析的步驟：
1. 拿到 NGS data 後，為了確保最終分析的正確，必須確保data是否具有夠好的 quality 可以進行分析，因此需要先做 **fastQC** 
    
2. NGS 的 raw data 為小片段，又可以區分為 short reads 及 long reads， 但不管是哪一種皆需與 reference genome 做比較，如同拼拼圖一般，將 raw data 中的片段（也就是 reads ) 拼回 genome 中的正確位置，也就是我們所做的 **alignment**。

3. 在做 NGS 的時候，  adaptor 會隨機與原始的DNA片段的兩端結合，然後複製產生新股的 DNA ，但因為這個步驟是隨機的，可能會重複接在已經做過的 DNA 上造成這個片段出現的頻率特別高，因此為了避免分析時造成誤會以為是這段序的 depth 特別深，我們會利用 **mark duplicate** 的方式排除掉不斷重複的相同序列。
 4. 在得到正確的 depth 及 quality 後就可以用 **variant calling** 開始我們的分析了。顧名思義， variant calling 就是找出 data sequence 中有 variant 的位置，比如 indel 及 SNV 。上課中我們使用的 GATK 就是一種 variant calling 的工具。
 5. 得到 variant 的資訊之後，我們利用與各種 database （比如 Taiwan Biobank database )的比較可以得知這些 variant 是否曾經被報導過以及是否有臨床意義等資訊，就是所謂的 **annotation**。

#### 所以綜合上述的所有內容，整體步驟如下：
    NGS raw data --> fastqc --> alignment --> Mark duplicates --> variant calling --> annotation
    
----------------------
有了上述的背景知識後，就可以開始寫 shell script 了。
 
你可以稍微想像一下，假設 shell script 是個麵包機好了，你給了他不一樣的麵團及設定不一樣的模式時會烤出不同的麵包。所以當你 input 一個檔案時，根據不同的 shell script ，會給出不一樣的 output 檔案。

shell script 是一個迷你的小程式，我們可以把每個步驟都寫成一個 shell script，當然也可以全部的步驟都寫在同一個 shell script 內。

以下我們將分段介紹每個部分的 shell script 內容，但在開始寫程式之前有一些小知識需要先了解一下:
    1. 在國網的介面中有幾件事必須先知道：檔案的位置及檔案的名稱，這就像是寄包裹的時候要有名字跟地址一樣，這部分非常重要，因為當你寫的 shell script 要用到檔案時你必須給對的路徑讓它可以找到檔案。
     -`pwd`: 用來查詢當前資料夾位置
     -`ls`:用來顯示當前資料夾中的所有檔案
     -`cd`:前往你要去的資料夾
     -`mkdir`：創建一個資料夾
    2. 打開 shell script 的方式：我們上課常用的 vim 是一個文字編輯器，當然還有很多別的編輯器，他的功能就是讓你打開檔案並編輯裡面的文字。
    3. shell script 的運行模式是逐行進行的，因此具有順序，會先執行上方的命令，再逐行往下。這件事的重要性在於定義路徑或是使用模組時，需要注意在執行命令時先決條件要先設定好。
    4. 在 shell script 中，要編輯的時候要按下按鍵`ｉ`，接著  shell script 中最下面會顯示 `----insert-----`，表示你進入了編輯模式，當你要退出編輯模式時請按鍵盤上的'esc'; 另外在離開編輯模式如果對這個 shell script 中有各種指令，、你的指令會顯示在畫面的左下角，比如存檔為`:w`，離開為`:q`(強制離開不儲存是`:q!`)，所以儲存並離開為`:wq`。
    5. 在 shell script 中有一些可以幫助你更方便工作的小工具， **注意，這些工具是在非編輯模式下使用**，因此你輸入的指令將會出現在視窗大左下角
     - `/set number`+`enter鍵`：將會在每一行的前方出現行數，可以方便你閱讀
     - `/key_word`+`enter鍵`：將 key_word 的部分換上你想要尋找的文字，將會幫助你在整個 shell script 中找尋這個字
    6. shell script 的檔案為 ".sh" 結尾的檔案
    7. 另外，通常為了方便我們了解程式進行到哪裡或是哪個位置出錯，通常我們會在某一段要執行的指令前加上`echo "start"`等字樣，讓程式在這個段落開始前告知你，並且在這個段落結束後也加上`echo "Finished"`。這樣這些文字在才會顯示在你的 log file 中。

  -----------------------------------
### 前情提要到這裡告一個段落，接下來為實際操作的內容
### step.1: 將檔案放到自己的國網上
#### 1. 請到 [ntu cool](https://cool.ntu.edu.tw/courses/42564) 中 Week 9 中下載兩個 fastq 檔案及兩個 sh 檔，其中 fastq 檔案是這次的實作課中的 raw data。
#### 2. 將檔案放到自己的國網帳號上
在上傳檔案之前，要在本機端去到你放剛下載下來檔案的資料夾中（意思就是在剛打開 CMD 或 terminal 還沒進入國網之前要先去到存剛剛下載的檔案的位置)，另外也要先想好要將檔案存到國網的哪個位置，建議可以在另一個 CMD 或 terminal 登入國網，可以利用`pwd`得知路徑，必要的話可以利用`mkdir`建立需要資料夾。

linux作業系統：
```
rsync -avz file_name username@t3-c4.nchc.org.tw:destination_dir
    
# rsync：一款高效的資料同步和傳輸工具，適合在本地與遠端之間或在兩台伺服器之間進行檔案或目錄同步。
# -a：archive，表示會同步包括子目錄在內的所有檔案和目錄，同時保留原始檔案的權限、時間戳和符號連結。
# -v：（verbose）詳細模式，顯示同步過程中的詳細資訊，讓你看到傳輸的檔案清單和進度。
# -z：（compress）壓縮資料，以減少傳輸過程中的資料量，提升同步速度，特別是在網速較慢的情況下非常有用。
    
```

Windows作業系統：
```markdown=
sftp username@t3-c4.nchc.org.tw
put example_file /directory/
    
#sftp：這是 Secure File Transfer Protocol 的縮寫，使用 SSH 協定進行安全的檔案傳輸。
#put:將本地檔案上傳到遠端伺服器。
    
```
    
### step.2: 修改 shell script
#### 在進行這一步驟時，需要先了解當前位置及各種需要使用的檔案位置
#### 1. 打開 sh 檔
```
vim file_name.sh  
    
# vim 是一種文字編輯器，幫助你編輯sh檔
# file_name.sh 是你的sh檔名稱
```

#### 2. 接下來打開來會看到以下的畫面
![截圖 2024-10-29 下午2.13.02](https://hackmd.io/_uploads/BkVNTgCl1l.png)

    
 ```
#!/usr/bin/sh
#SBATCH -A ACD113120          # Project name:是我們上課計畫的編號
#SBATCH -J fastqc             # Job name：這部分可更改，你可以取個自己喜歡的名字
#SBATCH -p ngscourse          # Partition Name
#SBATCH -c 2              
#SBATCH --mem=13g         
#SBATCH -o tutorial.out.log   # -o:表示匯出out.log檔，會紀錄程式裡面跑過的步驟
#SBATCH -e tutorial.err.log   # -e:表示匯出err.log檔，會紀錄程式裡fail的部分;另外如果沒有另外設定，這兩個log file都會存在sh檔的當前位置
#SBATCH --mail-user=          # 這部分可以輸入自己的email，會在發生下一行設定的情況下寄email給你
#SBATCH --mail-type=END
```  
#### 3.紀錄工作開始
![截圖 2024-10-24 下午4.07.16](https://hackmd.io/_uploads/H19BeFveJx.png)
:::success
#### 指令介紹
1. ```set -v -x ```:`set` 是一個內建的 shell 指令，用來設定或修改 shell 環境的參數。`-v`代表詳細模式，`-x`代表執行命令的結果，這個命令可以幫助執行script時了解進度與錯誤，這些資訊將會顯示在 err.log 中，不過你若是認為不需要，那也可以刪掉這一行。
2. ```echo "   "```:echo意思是輸出訊息，後面的"  "內就是輸出的內容。
:::

* ```echo "start"```
看到start代表分析開始了，藉此幫助我們了解階段性進度已完成。
* ```echo "$(date '+%Y-%m-%d %H:%M:%S')"```
輸出的訊息是當時的時間--年月日/時分秒

#### 4.先定義資料的路徑（就是你的檔案位置）及資料名稱（就是檔案名稱）
![截圖 2024-10-24 下午4.07.59](https://hackmd.io/_uploads/ByU_lKvx1x.png)


:::success
#### 指令介紹
1. `A=b`:等好在這邊是賦予的意思，也就是說這裡我們賦予a這個代號是b的內容，之後在輸入了A的時候會自動帶入b的內容。
2. `＄{}`：這主要是用來將變數的值嵌入到字串中，'$'是表示變數的意思。
:::
* ```R1=``` ```R2=```：定義R1及R2的名稱
* ```fastqdir```：定義fastq檔案的位置
* ```R1_file=``` ```R2_file=```：定義R1_file和R2_file的正確路徑
* ```echo "R1_file dorectory: " ${fastdir}/${R1_file}```:輸出`R1＿file`的路徑，這一條只是幫助你了解路徑有沒有設定正確



#### 5.建立一個資料夾存 fastqc 檔並執行 FastQC
![截圖 2024-10-24 下午4.09.01](https://hackmd.io/_uploads/rk42gKDxkl.png)
:::success
#### 指令介紹
1. `cd`：進入資料夾
2. `mkdir`：建立資料夾
3. `pwd`：顯示當前位置
4. ```fastqc ${file_1} ${file_2} -o ${directory}```： FastQC中的命令，用 file_1 及 file_2 當 input file，藉由FastQC跑完後將檔案output到＄{directory}這個位置。其中`-o`表示output的意思。
:::

* ```cd ${fastqdir}```：進入 ${fastqdir} 這個路徑
* ```mkdir fastqc_tutorial```：建立資料夾 `fastqc_tutorial`
* ```cd fastqc_tutorial```：進入剛建立的這個資料夾
* ```module load```：載入國網內建模組（FastQC）


#### 6. 定義後續分析的路徑及 reference genome 的位置
![截圖 2024-10-24 下午4.10.26](https://hackmd.io/_uploads/BkC-ZYwl1x.png)

* ```ref=```：定義 reference genome 的位置
* ```sampleR1=${fastqdir}/${R1}.fastq```：定義sampleR1的位置
* ```echo "sampleR1: " ${sampleR1}```:輸出sampleR1的位置，幫助你了解是否設定正確
* ```cd ${fastqdir}```：進入 fastqdir 這個位置
* ```mkdir -p ./tutorial```:在當前的目錄（./)下建立 tutorial資料夾。
`-p`是parents的縮寫，表示如果指定的目錄路徑中有不存在的上層目錄，會一併建立，不會顯示錯誤訊息。即使資料夾已存在，也不會出現錯誤。
* ```cd tutorial```：進入tutorial資料夾
* ```echo "pwd for analysis: "``` ```pwd```:顯示當前位置


#### 7.開始分析資料
![截圖 2024-10-24 下午4.12.15](https://hackmd.io/_uploads/Byq_-tPxyg.png)

:::success
#### 指令介紹
1. ```set -euo pipefail```：
    - `-e`：當任何一條指令執行失敗時， script 會立即退出，防止繼續執行並可能導致後續錯誤。

    - `-u`：當 script 中使用未定義的變數時，會直接報錯並退出。這可以幫助檢查變數是否已正確定義，避免意外的錯誤。

    - `-o pipefail`：如果一條管道（pipeline）中的任意一個指令失敗，整個管道會被視為失敗。
:::

* ```echo```：通知我們整個分析流程的開始並記錄時間
* ```module load```：載入國網內建模組（biology, BWA, SAMTOOLS）
* ```set -euo pipefail```:如果 script 出現錯誤會立即停止，預防錯誤後繼續執行得到錯誤結果。

#### 8. DNA alignment : BWA mapping
這邊用的工具是 BWA ( Burrows-Wheeler Aligner )

![截圖 2024-10-24 下午4.13.11](https://hackmd.io/_uploads/r1z2WtDeye.png)

:::success
#### 指令介紹
1. ```bwa mem -M -R "@RG\tID:GP_${sample}\tSM:SM_${sample}\tPL:ILLUMINA" -t 40 -K 1000000 ${ref} ${sampleR1} ${sampleR2} > ${sample}.sam```: 這是 BWA 的執行命令

* ```bwa mem```：使用 BWA 的 mem 模式進行alignment，適用於比對長度大於 70 bp 的 reads ，也是目前最常用的模式，適合 paired-end 的序列。
* ```-M```：標示出重複序列，之後 markduplicate 會用到。
* ```-R```：指定讀取 Group 。
* ```@RG```：讀取 Group 的標示。
* ```ID:GP_${sample}```：reads group 的 ID，這裡使用 GP_$ {sample} 表示。
* ```SM:SM_${sample}```： Sample Name ，這裡使用 SM_$ {sample}。
* ```PL:ILLUMINA```：定序平台( platform )，這裡是ILLUMINA。
* ```-t 40```：指定使用的線程數，可以加快比對速度。
* ```-K 1000000```：設定緩衝區減少內存消耗。
* ```${ref}```：參考文件。
* ```${sampleR1} ,${sampleR2}```：input data。
* ```>```: 生成檔案。
* ```${sample}.sam```：output data。
:::

* ```echo```：通知我們BWA mapping開始和結束與記錄時間。
* ```bwa``` :執行 BWA mapping。


#### 9.利用 SAMTOOLS 將 sam 檔轉換成之後需要的 bam 檔
![截圖 2024-10-24 下午4.13.53](https://hackmd.io/_uploads/r16RbtDxkx.png)

:::success
#### 指令介紹
1. ```samtools view -@ 2 -S -b ${sample}.sam > ${sample}.bam```：SAMTOOLS指令。
* ```-@ 2```: 指定使用線程數。
* ```-S```: 指定輸入文件格式 sam 檔。
* ```-b```: 指定輸出文件格式 bam 檔。
* ```${sample}.sam```: input data。
* ```${sample}.bam```: output data。
2. ```samtools sort -@ 2 ${sample}.bam -o ${sample}.sorted.bam```：SAMTOOLS指令。
* ```samtools sort```: 將bam檔案按照染色體排列。
* ```-@ 2```:指定使用線程數 。
* ```${sample}.bam```: input data。
* ```-o ${sample}.sorted.bam```: output data。
3. ```samtools index -@ 20 ${sample}.sorted.bam```：SAMTOOLS指令。
* ```samtools index```:建立 bam 檔索引。
* ```-@ 20```:指定使用線程數。
* ```${sample}.sorted.bam```: input data。

:::

* ```echo```：通知我們 SAMTOOLS sorting 開始和結束與時間紀錄。
* ```samtool```：將 sam 檔轉成 bam 檔。
    
#### 10. Mark duplicates
![截圖 2024-10-24 下午4.14.30](https://hackmd.io/_uploads/B1m-MKvxJg.png)

:::success
#### 指令介紹
1. ```java -jar ${PICARD} MarkDuplicates -I ${sample}.sorted.bam -O ${sample}.sorted.markdup.bam -M ${sample}_markdup_metrics.txt --CREATE_INDEX true```：是Picard 指令。
* ```java -jar ${PICARD}```:使用 java 執行 picard 中的 jar 檔。
* ```MarkDuplicates```: Picard 中的模組，會標記 bam 檔中的重複 reads。
* ```-I ${sample}.sorted.bam```: input data。
* ```-O ${sample}.sorted.markdup.bam```: output data。
* ```-M ${sample}_markdup_metrics.txt```: 將重複 reads 的綜合統計資訊保存到 ${sample}_markdup_metrics.txt 檔案中。
* ```--CREATE_INDEX true```: 自動生成 bam 檔索引。
:::


* ```echo```：通知我們Picard mark duplicates開始和結束與時間紀錄。
* ```PICARD=...```：指定PICARD的路徑及版本。
* ```java ...```:執行 Mark duplicates。

    
#### 11. 利用 GATK Haplotypecaller 做 Variant Calling
![截圖 2024-10-24 下午4.15.27](https://hackmd.io/_uploads/SyOEfKPlJx.png)

:::success
#### 指令介紹
1.```gatk HaplotypeCaller \
  -R /opt/ohpc/Taiwania3/pkg/biology/reference/Homo_sapiens/GATK/hg38/Homo_sapiens_assembly38.fasta \
  -I ${sample}.sorted.markdup.bam \
  -O ${sample}.sorted.markdup.hc.vcf.gz \
  -L chr1 -L chr2 -L chr3 -L chr4 -L chr5 -L chr6 -L chr7 -L chr8 -L chr9  \
  -L chr10 -L chr11 -L chr12 -L chr13 -L chr14 -L chr15 -L chr16 -L chr17  \
  -L chr18 -L chr19 -L chr20 -L chr21 -L chr22```：GATK指令。

* ```gatk HaplotypeCaller```: 使用 GATK 的 HaplotypeCaller 模組進行 variant calling。     

* ```-R /opt/ohpc/Taiwania3/pkg/biology/reference/Homo_sapiens/GATK/hg38/Homo_sapiens_assembly38.fasta \```:指定 reference gene。
* ```-I ${sample}.sorted.markdup.bam```: input data。
* ```-O ${sample}.sorted.markdup.hc.vcf.gz```: output data。
* ```-L chr1 ... -L chr22```: 指定分析範圍。
:::

* ```echo```：通知我們 GATK calling variants 開始和結束與時間紀錄。
* ```module load```載入國網內建模組（Anaconda,GATK）
* ```gatk HaplotypeCaller...```：執行 variant calling。


    


#### 12. Split multiallelic
![截圖 2024-10-29 下午2.18.21](https://hackmd.io/_uploads/ByNT1-Al1x.png)

:::success
#### 指令介紹
1.```${BCFTOOLS} norm -m -any ${sample}.sorted.markdup.hc.vcf.gz \
    -Oz \
    -o ${sample}.sorted.markdup.hc.normed.vcf.gz```：BCFTOOLS指令。

* ```${BCFTOOLS} norm```:使用 bcftools 的 norm 命令對 VC F檔案進行標準化。
* ```-m -any```:將多個等位基因分成單一個等位基因，以确保每行只包含一個等位基因，可以簡化分析。
* ```${sample}.sorted.markdup.hc.vcf.gz```: input data。
* ```-Oz```:將 output data 壓縮成BGZF格式。
* ```-o ${sample}.sorted.markdup.hc.normed.vcf.gz```: output data。
:::


* ```echo```：通知我們BCFTOOLS split multiallelic開始和結束與時間紀錄。
* ```${BCFTOOLS}...```：執行 Split multiallelic。


#### 13. 定義後續需要使用的路徑及模組
![截圖 2024-10-29 下午2.20.49](https://hackmd.io/_uploads/By5UJZRxJx.png)


:::success
#### 指令介紹
1. ```export PATH=${PATH}:...```: 將新路徑加入到環境變數 `PATH` 中，使指定的路徑中的執行檔可以在當前 script 中直接執行，讓我們下命令時不必輸入完整路徑，且也不影響原路徑。
:::

* `VEP_PATH=` `VEP_CACHE_DIR=` `VEP_FASTA=` `BCFTOOLS=`：指定名稱與路徑
* ```module load```：載入國網內建模組（biology, Perl, Anaconda,）。
* ```export PATH=${PATH}:...```: 將當前的`PATH`加上新的路徑。
```set -euo pipefail```如果script出現錯誤會立即停止。


    
#### 14.利用 VEP 做 annotation
![截圖 2024-10-28 晚上10.51.58](https://hackmd.io/_uploads/Sk07B7axkg.png)
![截圖 2024-10-24 下午4.17.24](https://hackmd.io/_uploads/HJOsGFDxke.png)

:::success
#### 指令介紹
1.```${VEP_PATH} --cache --offline \
--cache_version 108 --dir_cache ${VEP_CACHE_DIR} \
--assembly GRCh38 \
--fasta ${VEP_FASTA} \
--fork 4 \
-i ${INPUT_VCF} \
--check_existing \
--af_gnomade \
--af_gnomadg \
--vcf \
-o ${SAMPLE_ID}.vcf \
--force_overwrite```：VEP指令
* ```--cache```:使用緩存 annotation 的資料(不必遠端連線)。
* ```--offline```:離線模式。
* ```--cache_version 108```:使用缓存的第108版本。
* ```--dir_cache ${VEP_CACHE_DIR}```:指定緩存的目錄。
* ```--assembly GRCh38```:使用 GRCh38 reference gene 進行 annotation。
* ```--fasta ${VEP_FASTA}```: 使用 GRCh38 reference的 FASTA 檔。
* ```--fork 4```:指定線程數。
* ```-i ${INPUT_VCF}```: input data。
* ```--check_existing```:檢測 variants 是否有出現在資料庫中。
* ```--af_gnomade 和 --af_gnomadg```:加入 gnomAD 資料庫的等位基因頻率資訊（ exome 和 genome 都有）。
* ```--vcf```: output data 格式為 VCF。
* ```-o ${SAMPLE_ID}.vcf```: output data。
* ```--force_overwrite```:覆蓋已存在的重複文件（節省空間）。

:::
* ```echo```：通知我們 VEP annotation 開始和結束與時間紀錄。
* ```${VEP_PATH}...```：執行 annotation。

---------------------
### 練習
將 variant calling 的方式由 GATK Haplotypecaller 改為 GATK Mutect2
1. 首先需要先複製一份 `tutorial.sh`，並命名為 `tutorial_mutect2.sh`。
```
cp tutorial.sh tutorial_mutect2.sh
```
2. 開啟 `Mutect2.sh`，並將裡面的內容複製並置換 `tutorial_mutect2.sh`中 variant calling 的部分。
3. 修改 `tutorial_mutect2.sh` 中的參數。
**提示：需要修改的內容為**
  (1) 開頭部分 err.log 及 out.log 的檔案名稱。
  (2) variant calling 時 output file 的檔案名稱。
  (3) 因為 variant calling 時 output file 改名而造成變動的檔案名稱。
  <span style="color: red;">注意～如果沒有完整修改的話，當 output 檔案名稱與剛剛用 hapltypecaller 做出來的檔案名稱相同時，將會覆蓋掉之前的檔案。<span>
3. 執行修改好的 shell script。
