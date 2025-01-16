# 20240925 Fantastic Genomic Biomarkers and Where to Find Them Practical Course (part IV)
-----------
:warning: **Warning**
### TA Reminder
#### 1. Introduction to NCHC Folder Hierarchy
![image](https://hackmd.io/_uploads/HJ01rw3TC.png)

![image](https://hackmd.io/_uploads/rJzqBw26R.png)


*** **Please execute the course content under work/$user** ***

#### 2. How to Use `mv`
`mv` is a command-line tool used for moving or renaming files and directories, widely used in Linux and macOS systems. The mv command helps you move files or directories from one location to another, or rename files or directories.
- Move a file:`mv <source_file> <destination_directory>/`
- Rename a file:`mv <old_filename> <new_filename>`
- Move and rename a file:`mv <source_file> /<new_directory>/<new_filename>`
- Move the directory:`mv <source_directory>/ <destination_directory>/`




## Main Content of the Course
1. Use BWA for alignment
2. <span style="color: red;">Use Picard to mark duplicates</span>
3. Use ThinLinc to open IGV and view the alignment/MarkDuplicates results
Therefore, you must download ThinLinc beforehand. For more details, refer to this link.(https://hackmd.io/speUUZSNRZe0n_EAIl2lig)
4. If time permits, compare the results from this week with last week's.
### Reminder: This session will mainly review the previous content, with the additional step of marking duplicates.

## Alignment/MarkDuplicates

ℹ️

#### What is Picard?
- Picard is a genomic data analysis toolkit designed specifically for handling high-throughput sequencing data. It provides a wide range of powerful tools to assist users in performing various operations during the analysis process, such as MarkDuplicates, manipulating read groups, Sorting and indexing files, data-cleanup operations, statistical analysis, and format conversion. Picard is widely used in workflows for variant detection and genome analysis.



#### What is MarkDuplicates?
- In genomics and next-generation sequencing (NGS), duplicate reads refer to multiple reads originating from the same original DNA molecule during the sequencing process. These duplicate reads are typically produced due to the PCR amplification process, where DNA polymerase replicates the template DNA during each amplification cycle, doubling the amount of DNA with each cycle. In theory, this should produce a large number of identical DNA fragments. However, certain DNA fragments are amplified more efficiently than others during PCR, which can affect the representativeness and accuracy of the final sequencing data. This can result from factors such as primer design, GC content of the DNA sequence, secondary structures of the DNA (e.g., hairpins), PCR temperature and time, and the efficiency of the DNA polymerase.
- **Thus, we use MarkDuplicates to identify and mark duplicate reads. This process typically occurs after alignment and is intended to prevent errors in subsequent analyses caused by duplicate reads originating from the same DNA sequence.**




### Step 1: Create a Path on the NCHC  
1. Log in to the NCHC (For those who forgot how to log in, please refer to this link(https://hackmd.io/jcvG9iIiRW6DTUysi8AKug)).
2. Enter the "alignment" folder.
```marksown=
cd /work/username/alignment
```
3. Copy the executable files needed for the class.
```marksown=
rsync -avz /work/u2499286/alignment/bwa_markdup.sh /work/username/alignment
```

### Step 2: Modify the Analysis Executable
1. Enter bwa_markdup.sh
```
vim bwa_markdup.sh
```

2. Please press "i" to modify the following code:
>The following serves as an example based on the files in the bwa_markdup.sh folder (format should follow the examples provided within, do not include the file extension).
![image](https://hackmd.io/_uploads/Hk-Q7It6A.png)

```
(1) #SBATCH -A ACD113120           #Account name/project number
(2) #SBATCH -J alignment           ###Job name:可修改
(3) #SBATCH -p ngscourse           ###Partition Name:等同PBS裡面的 -q Queue name
(4) #SBATCH -c 2                   #使用的core數:請參考Queue資源設定
(5) #SBATCH --mem=13g              #使用的記憶體量 請參考Queue資源設定
(6) #SBATCH -o out_almark.log          ###Path to the standard output file:可修改
(7) #SBATCH -e err_almark.log          ###Path to the standard error ouput file:可修改
(8) #SBATCH --mail-user=           ###e-mail:可修改
(9) #SBATCH --mail-type=END        ###指定送出email時機:可為NONE, BEGIN, END, FAIL, REQUEUE, ALL
```

3. Enter your account in any location marked as <span style="color: red;">username</span>.

![image](https://hackmd.io/_uploads/H1Yo8qbTA.png)


The step we add today
![image](https://hackmd.io/_uploads/SktMvx-R0.png)

4. Enter `:wq` to save and exit.
```
:wq
```
5. Execute the script
(1) Enter the following command to submit the edited draft as an sbatch job:
```
sbatch bwa_markdup.sh
```
(2) If submitted successfully, the following message will appear (after the bwa_markdup.sh file completes running, an alignmentRM folder will be automatically created under the alignment directory to store the results):
![image](https://hackmd.io/_uploads/Sk5mqIYT0.png)


(3) You can use the following command to check the status of the job execution:
```
sacct
```
![image](https://hackmd.io/_uploads/SkeIcLYTR.png)

6. Check the results: The "alignmentRM" folder will contain `sam` and `bam` files. Confirm the integrity of the files with the detailed steps listed below.
(1) Open the "alignmentRM" folder: You can use either a relative or absolute path.
```markdown=
cd alignmentRM                            # Use relative path
cd /work/username/alignment/alignmentRM   # Or use absolute path
```
(2) Confirm that the files exist:
```
ls
```
(3) Check the integrity of the files:
```
less SRR13076392_S14_L002_.sam
```
(4) Use `Shift` + `g` to view the bottom of the file. 
![image](https://hackmd.io/_uploads/HJUrZ7B60.png)

(5) Exit:
```
q
```

## View Results with IGV
:warning: **Warning**
### :warning:<Previous information> :warning:
Since the alignment/MarkDuplicates step in bwa takes a long time, the results used in the following steps are those already generated by the TA. Please first copy the results from the TA into the alignment folder (both files are required).
```
rsync -avz /work/u2499286/alignment/alignmentRM/SRR13076392_S14_L002_.sorted.markdup.bam ./
rsync -avz /work/u2499286/alignment/alignmentRM/SRR13076392_S14_L002_.sorted.markdup.bai ./
```




### Step 1: Use ThinLinc to Open IGV
1. Use ThinLinc to open a terminal.
2. In the terminal, use the `sh` command to open the IGV software:
```
sh /opt/ohpc/Taiwania3/pkg/biology/IGV/IGV_v2.10.3/igv.sh
```
3. Use the area in the upper left corner of the screen to select the corresponding reference genome.
![HYRsUmf](https://hackmd.io/_uploads/HJa0cGxpA.png)

(1) Select "More..." from the dropdown menu in the upper left corner.  
![upload_5665be535b603da2fd1d955771c76554](https://hackmd.io/_uploads/BJmviGeTC.jpg)
    
(2)Search for hg38 and download Human hg38.
![upload_137c491955544cb3bfb7e23c7490ade3](https://hackmd.io/_uploads/B1loizeaR.png)

(3)Use **File → Load from file** in the upper left corner to import SAM and BAM files (using BAM files as an example). The files are located at the following path:
* bam file:`/work/username/alignment/SRR13076392_S14_L002_sorted.markdup.bam`


    ![image](https://hackmd.io/_uploads/S1dHkQFTR.png)

(4)In the upper left corner, you can select the chromosome and range to view (blue box), while in the upper right corner (red box), you can select the view size (you may need to zoom in to a sufficient scale to see the results). 
     ![image](https://hackmd.io/_uploads/H1Ys1XK60.png)
    
>For example, using chr16:

>- Enter 16:175,000-178,500 in the box above (you can >adjust the range as needed). If successful, the result will be displayed as shown in the image below.
>![image](https://hackmd.io/_uploads/r1myUreTA.png)   
 >   
>- Right-click in the gray area on the left side.
>    1. Check "View as pairs."
>    2. Select "Color alignments by → insert size and pair >orientation."
>    3. Choose "Sort alignments by → insert size."
 ![image](https://hackmd.io/_uploads/Hkr0ckj80.png)

If you want to understand what each read's color represents in IGV, you can refer to the following link:
https://igv.org/doc/desktop/#
[User Guide > Tracks and Data Types > Alignments > Paired-end alignments > Detecting structral variants]

### Step 2: Observe the Impact of MarkDuplicates (Compare This Week's and Last Week's Results)
![image](https://github.com/user-attachments/assets/e3fcb523-584f-4ba7-80af-b03eda58d386)
If you want to know th details about bwa :https://bio-bwa.sourceforge.net/bwa.shtml

## FastQC Report
#### Introduction to the FastQC Report from Course II
1. Fastqc report
![image](https://hackmd.io/_uploads/SJgWblgCR.png)

2. Per base sequence quality
![image](https://hackmd.io/_uploads/BySxllgCA.png)

3. Per sequence quality scores
 ![image](https://hackmd.io/_uploads/r1LbexeCR.png)

4. Per base sequence content
![image](https://hackmd.io/_uploads/H1KfeggAA.png)

5. Per sequence GC content
![image](https://hackmd.io/_uploads/ryaNelgRC.png)

6. Per base N content
![image](https://hackmd.io/_uploads/HJbLgxeCC.png)

7. Sequence Length Distribution
![image](https://hackmd.io/_uploads/S1fPlxeAR.png)

8. Sequence Duplication Levels
![image](https://hackmd.io/_uploads/rkp_eggRR.png)

9. Overrepresented sequences
10. Adapter Content
![image](https://hackmd.io/_uploads/S1Y2egeCA.png)

-------------------------

:warning: **Warning**

### 課前助教小提醒~
#### 1. NCHC資料夾層級介紹
![image](https://hackmd.io/_uploads/BymXkrFT0.png)
![image](https://hackmd.io/_uploads/rkYAvrYTA.png)

*** **上課內容請在`work/$user`之下執行** ***
#### 2. 如何使用`mv`
- `mv` 是一個用於移動或重新命名文件和資料夾的命令行工具，在 Linux 和 macOS 系統中廣泛使用。`mv` 命令可以幫助你將文件或目錄從一個位置移動到另一個位置，或者將文件或目錄重新命名。
- 移動文件:`mv <source_file> <destination_directory>/`
- 重新命名:`mv <old_filename> <new_filename>`
- 移動並重新命名:`mv <source_file> /<new_directory>/<new_filename>`
- 移動目錄:`mv <source_directory>/ <destination_directory>/`


## 本次課程主要內容
 1. 利用BWA做alignment
 2. <span style="color: red;">**利用picard做mark duplicates**</span>
 3. 用thinlinc打開IGV查看alignment/ MarkDuplicates後的結果
所以在這之前必須要先下載好thinlinc，詳細[連結](https://hackmd.io/speUUZSNRZe0n_EAIl2lig)可見此
4. 若有時間可以比較本週與上週的結果

### 提醒:本次課程主要複習上次內容，並多加入Mark duplicates的步驟
 ## Alignment/MarkDuplicates

ℹ️ 
#### 甚麼是Picard?
Picard 是一套genomic data analysis，專為處理高通量測序數據設計，提供了一系列功能強大的工具，幫助用戶在分析過程中進行各種操作，提供如 MarkDuplicates、調整讀數群組、重新排序、數據清理、統計分析和格式轉換等功能，廣泛應用於變異檢測和基因體分析的工作流程中。


#### 甚麼是MarkDuplicats?

- 在Genomics和次世代定序（NGS）中，重複讀數（duplicate reads）是指在定序的過程中由同一原始DNA分子產生的多個讀數。這些讀數的出現通常是由於PCR amplification的過程造成的，在每個擴增循環中，DNA polymerase會複製template DNA，使得每個循環後的DNA量都會成倍增加。理論上，這應該會產生大量相同的DNA片段，但因PCR的過程中，某些DNA片段的擴增效率比其他片段高，會影響最終測序數據的代表性和準確性。這種影響可能源於幾個因素：Primer的設計、DNA sequence的GC含量、DNA的二級結構(hairpin)、PCR的溫度時間及DNA polymerase的效率等。
- **因此我們利用MarkDuplicates來辨識並標記 duplicate reads。這個過程通常在比對alignment之後進行，主要目的是防止來自同一個DNA序列因為重複讀數在後續分析中引起錯誤結果。**


### step 1在國網上建立路徑
1. 登入國網（忘記怎麼登入的人請參見[連結](https://hackmd.io/jcvG9iIiRW6DTUysi8AKug)）
2. 進入alignment資料夾
```marksown=
cd /work/username/alignment
```
3. 複製上課所需執行檔
```marksown=
rsync -avz /work/u2499286/bwa.sh /work/username/alignment
```
### step 2 修改分析執行檔


1. 進入bwa_markdup.sh
```
vim bwa_markdup.sh
```

2. 請輸入`i`更改以下程式碼：
> 以下以bwa_markdup.sh資料夾中的做為示範 (格式請依照裡面給你的範例，副檔名不用寫進去)


![image](https://hackmd.io/_uploads/Hk-Q7It6A.png)


```
(1) #SBATCH -A ACD113120           #Account name/project number
(2) #SBATCH -J alignment           ###Job name:可修改
(3) #SBATCH -p ngscourse           ###Partition Name:等同PBS裡面的 -q Queue name
(4) #SBATCH -c 2                   #使用的core數:請參考Queue資源設定
(5) #SBATCH --mem=13g              #使用的記憶體量 請參考Queue資源設定
(6) #SBATCH -o out_almark.log          ###Path to the standard output file:可修改
(7) #SBATCH -e err_almark.log          ###Path to the standard error ouput file:可修改
(8) #SBATCH --mail-user=           ###e-mail:可修改
(9) #SBATCH --mail-type=END        ###指定送出email時機:可為NONE, BEGIN, END, FAIL, REQUEUE, ALL
```
3. 在任何<span style="color: red;">username</span>的位子輸入自己的主機帳號    

![image](https://hackmd.io/_uploads/H1Yo8qbTA.png)


本次加入步驟      
![image](https://hackmd.io/_uploads/SktMvx-R0.png)

4. 輸入`:wq`儲存離開
```
:wq
```
5. 執行script

(1) 輸入以下指令，來以sbatch job的方式送出編輯完成的草稿
```
sbatch bwa.sh
```


(2) 若送出成功將會出現以下文字 (`bwa.sh`的檔案跑完後會自動在alignmnet資料下建立一個alignmentRM資料夾，將結果放在裡面)

![image](https://hackmd.io/_uploads/Sk5mqIYT0.png)


(3) 可使用以下指令查看工作執行情況
```
sacct
```
![image](https://hackmd.io/_uploads/SkeIcLYTR.png)


 6. 查看結果:在`alignmentR`資料夾中會有`sam`,`bam`檔，並確認檔案完整性，詳細步驟逐條列在下面

(1) 開啟alignmentRM資料夾:可使用相對路徑或絕對路徑
```marksown=
cd alignmnetRM                            #可使用相對路徑
cd /work/username/alignment/alignmentRM   #或使用絕對路徑
```

(2) 確認檔案存在:
```
ls
```
(3) 確認檔案完整性:
```
less SRR13076392_S14_L002_.sam
```
(4) 利用 shift+g 查看檔案最底部

![image](https://hackmd.io/_uploads/HJUrZ7B60.png)

(5) 退出:
```
q
```


 ## 用IGV察看結果
 
:warning: **Warning**

### :warning: <前情提要> :warning:
由於bwa在執行alignment/ MarkDuplicates的時間較長，所以執行以下步驟時使用的都是助教已經跑出的結果，請先複製助教的結果到alignment資料夾底下(兩個檔案都要)

```
rsync -avz /work/u2499286/S14_HC_result/SRR13076392_S14_L002.sorted.bam ./
rsync -avz /work/u2499286/S14_HC_result/SRR13076392_S14_L002.sorted.bam.bai ./
```

### step 1使用thinlinc、開啟IGV
1. 使用thinlinc、開啟 'Xfce terminal'
2. 在terminal利用`sh`指令開啟IGV軟體
```
sh /opt/ohpc/Taiwania3/pkg/biology/IGV/IGV_v2.10.3/igv.sh
```


3. 透過畫面左上角的區域來選取相對應的reference genome
![HYRsUmf](https://hackmd.io/_uploads/HJa0cGxpA.png)




(1) 左上角下拉選單選取**More...**
    ![upload_5665be535b603da2fd1d955771c76554](https://hackmd.io/_uploads/BJmviGeTC.jpg)


(2) 搜尋**hg38**，下載**Human hg38**
    ![upload_137c491955544cb3bfb7e23c7490ade3](https://hackmd.io/_uploads/B1loizeaR.png)



    
(3) 透過左上角的**File → Load from file**可匯入sam檔及bam檔(在這以bam檔為範例)，檔案位於以下路徑：

* bam file:`/work/username/alignment/SRR13076392_S14_L002_sorted.markdup.bam`


![image](https://hackmd.io/_uploads/S1dHkQFTR.png)



(4) 左上角可選取要看的染色體以及範圍（藍色框），右上角（紅色框）可選取要看的大小（需要放大到足夠的級距才能看到結果）
    ![](https://hackmd.io/_uploads/rkfvbOYPh.jpg)

> 以*chr16*為例：
> * 請在上方輸入**16:175,000-178,500**（可自行調整級距），若成功開啟會呈現如下圖的結果
![image](https://hackmd.io/_uploads/H1Ys1XK60.png)


> * 在左側灰色區域點右鍵
>   1. 勾選 "View as pairs"
>   2. Color alignments by → insert size and pair orientation
>   3. Sort alignments by → insert size     
>     ![image](https://hackmd.io/_uploads/Hkr0ckj80.png)

若你想要了解在 IGV 中每個 read 的顏色所代表的意義，可以參考以下連結(https://igv.org/doc/desktop/#)
[User Guide > Tracks and Data Types > Alignments > Paired-end alignments > Detecting structral variants]

### step 2 觀察MarkDuplicates這步驟的影響(比較本週及上週結果)
![image](https://github.com/user-attachments/assets/060d1b33-3d47-440c-98bf-e46ef70834ec)
如果想知道bwa的詳細內容:https://bio-bwa.sourceforge.net/bwa.shtml


### Fastqc Report介紹
#### 介紹第二週做出來的fastqc report
1. Fastqc report
![image](https://hackmd.io/_uploads/SJgWblgCR.png)

2. Per base sequence quality
![image](https://hackmd.io/_uploads/BySxllgCA.png)

3. Per sequence quality scores
 ![image](https://hackmd.io/_uploads/r1LbexeCR.png)

4. Per base sequence content
![image](https://hackmd.io/_uploads/H1KfeggAA.png)

5. Per sequence GC content
![image](https://hackmd.io/_uploads/ryaNelgRC.png)

6. Per base N content
![image](https://hackmd.io/_uploads/HJbLgxeCC.png)

7. Sequence Length Distribution
![image](https://hackmd.io/_uploads/S1fPlxeAR.png)

8. Sequence Duplication Levels
![image](https://hackmd.io/_uploads/rkp_eggRR.png)

9. Overrepresented sequences
10. Adapter Content
![image](https://hackmd.io/_uploads/S1Y2egeCA.png)
