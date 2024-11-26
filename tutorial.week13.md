## 20241127 Fantastic Genomic Biomarkers and Where to Find Them Practical Course (part IIX)

## Main Content of the Course

#### Using `hap.py` to compare the analysis results of HaplotypeCaller and Mutect2 to understand their performance and accuracy in differnt scenarios.

:::info
#### What is `hap.py`?

`Hap.py` (Haplotype Comparison Tools) is a tool used for comparing genomic variants. It is often utilized to evaluate the accuracy of variant calling algorithms, especially in identifying variants such as SNPs and Indels in somatic or germline cells. `Hap.py` can be used to compare variant calling results with known standards (e.g., a gold standard VCF) to assess the sensitivity, precision, and other metrics of variant detection methods.
:::

### Step 1 : Using Singularity to Retrieve `hap.py` from Docker
1. Log in to NCHC and navigate to the `work` folder.
```
cd work/username
```
3. Use Singularity to pull `hap.py` from Docker:
```
singularity pull docker://pkrusche/hap.py
```
### Step 2 : Running `hap.py`
1. Copy the execution script needed for the task:
```
rsync -avz /work/u2499286/hap.sh ./
rsync -avz /work/u2499286/KnownPositives_hg38_Liftover.vcf ./
rsync -avz /work/u2499286/High-Confidence_Regions_v1.2.bed.gz ./
```
2. Write the correct path: 
    (1) Replace the <font color="#f00">red</font> part with your own username instead of the TA's. 
    (2) Change the <font color="#1936C9">blue</font> part to match your file name. 
    (3) Replace the <font color="#F7A004">yellow</font> part with your own file path.

![截圖 2024-11-22 下午4.06.36](https://hackmd.io/_uploads/Hy6sj3aGJe.png)
![截圖 2024-11-22 下午4.10.18](https://hackmd.io/_uploads/B15YhnTzye.png)
![截圖 2024-11-22 下午4.12.31](https://hackmd.io/_uploads/SyLZahafJl.png)
#### <font color="#f00">Reminder </font>: The bcftools command is used to remove multiallelic variants from the VCF file to ensure compatibility with `hap.py`.
3. Execute `Hap.sh`:
```
sbatch hap.sh
```
4. Results: A total of 11 files.
- output_prefix.runinfo.json
- output_prefix.metrics.json.gz
- output_prefix.roc.Locations.SNP.csv.gz
- output_prefix.roc.Locations.SNP.PASS.csv.gz
- output_prefix.roc.Locations.INDEL.csv.gz
- output_prefix.roc.Locations.INDEL.PASS.csv.gz
- output_prefix.roc.all.csv.gz
- output_prefix.summary.csv
- output_prefix.extended.csv
- output_prefix.vcf.gz
- output_prefix.vcf.gz.tbi

### Step 3 : Create an ROC plot using the results from `rocplot.sh`
1. Copy the execution script needed for the task:
```
rsync -avz /work/u2499286/rocplot.sh ./
rsync -avz /work/u2499286/rocplot_test.Rscript ./
```
2. Enter R and load the required packages.
```markdown=
R
install.packages("ggplot2")
61
install.packages("tools")
q()
n
```
3. Update the correct path: 
    (1) Ensure the <font color="#1936C9">blue</font> part specifies whether it is a **HaplotypeCaller or Mutect2 file.** 
    (2) Replace the <font color="#f00">red</font> part with your own **username.**
![截圖 2024-11-18 晚上9.08.15](https://hackmd.io/_uploads/B1W8fa_zkg.png)
4. Execute `rocplot.sh`:
```
sbatch rocplot.sh
```
5. Save the results in the rocplot_HC or rocplot_M2 folder, each containing two plots.
![截圖 2024-11-18 凌晨12.20.45](https://hackmd.io/_uploads/rkSlu5PzJe.png)




--------------------------------
# 生物標記物與它們的產地實作課程(八)
## 本次課程主要內容
    
#### 利用`hap.py`比較 Haplotypecaller 和 Mutect2 的分析結果，以了解它們在不同情境下的性能和準確性。
<span style="color: red;"> </span>
 
:::info
#### 什麼是`hap.py`？
`Hap.py`（Haplotype Comparison Tools）是一個用於比較基因組變異的工具。它經常被用來評估 variant calling 算法的準確性，特別是在體細胞或生殖細胞中的 SNPs 和 Indels 等變異的識別。`Hap.py` 可以用來對比 variant calling 結果與已知的標準答案（例如 gold standard VCF ），以評估變異檢測方法的靈敏度 (Recall)、精確度 (Precision)等指標。
:::

### step 1 : 執行`hap.py`

1. 複製上課所需執行檔與標準檔
```
rsync -avz /work/u2499286/hap.sh ./
rsync -avz /work/u2499286/KnownPositives_hg38_Liftover.vcf ./
rsync -avz /work/u2499286/High-Confidence_Regions_v1.2.bed.gz ./
```
2. 寫入正確的路徑名稱
    (1) <font color="#f00">紅色</font>部分助教的 **username** 改成自己的。
    (2) <font color="#1936C9">藍色</font>的檔案名稱隨你的檔案改變。
    (3) <font color="#F7A004">黃色</font>部分改成自己的檔案路徑。
![截圖 2024-11-22 下午4.06.36](https://hackmd.io/_uploads/Hy6sj3aGJe.png)
![截圖 2024-11-22 下午4.10.18](https://hackmd.io/_uploads/B15YhnTzye.png)
![截圖 2024-11-22 下午4.12.31](https://hackmd.io/_uploads/SyLZahafJl.png)

    #### <font color="#f00">提醒</font>：bcftools 命令的部分是將 vcf 檔中的 multialelic 去除，以便`hap.py`可以讀取。
3. 執行```hap.sh```
```
sbatch hap.sh
```
4. 得到結果 : 共11個檔案。
- output_prefix.runinfo.json
- output_prefix.metrics.json.gz
- output_prefix.roc.Locations.SNP.csv.gz
- output_prefix.roc.Locations.SNP.PASS.csv.gz
- output_prefix.roc.Locations.INDEL.csv.gz 
- output_prefix.roc.Locations.INDEL.PASS.csv.gz
- output_prefix.roc.all.csv.gz
- output_prefix.summary.csv
- output_prefix.extended.csv
- output_prefix.vcf.gz
- output_prefix.vcf.gz.tbi




### step 3 : 利用`rocplot.sh`結果製作 ROC 圖
1. 複製上課所需執行檔
```
rsync -avz /work/u2499286/rocplot.sh ./
rsync -avz /work/u2499286/rocplot_test.Rscript ./
```
2.進入R，載入需要的 package
```markdown=
R
install.packages("ggplot2")
61
install.packages("tools")
q()
n
```

3. 更改正確路徑
    (1) <font color="#1936C9">藍色</font>的部分須注意是 **Haplotypecaller 或是 Mutect2 的檔案**。
    (2) <font color="#f00">紅色</font>的部分需換成自己的 **username**。
![截圖 2024-11-18 晚上9.08.15](https://hackmd.io/_uploads/B1W8fa_zkg.png)

4. 執行`rocplot.sh`
```
sbatch rocplot.sh
```
5. 得到結果存於 rocplot_HC 或 rocplot_M2 資料夾，裡面各有兩張圖。
![截圖 2024-11-18 凌晨12.20.45](https://hackmd.io/_uploads/rkSlu5PzJe.png)
