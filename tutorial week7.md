## 20241016 Fantastic Genomic Biomarkers and Where to Find Them Practical Course (part VI)
## Main Content of the Course
1.Use VEP for annotation.


#### What is Annotation?
**Annotation** refers to the functional annotation of biological sequences (such as DNA, RNA, and proteins) to help interpret their biological significance. It primarily includes structural information, used to mark the location of genes, such as exons and introns, and functional information, used to predict the biological function of genes or the role of proteins. This helps us understand the relationship between structure and function.


#### Introduction to VEP
**VEP (Variant Effect Predictor)** is a tool developed by Ensembl, used to analyze genetic information, especially to assess the impact of different variants in genes (such as SNVs, insertions, deletions, and structural variants) on biological function. It is particularly suitable for annotation purposes.


### Step 1: Create a Path on the NCHC 
1. Log in to the NCHC (For those who forgot how to log in, please refer to this link(https://hackmd.io/jcvG9iIiRW6DTUysi8AKug)). 

2.  Enter the "variantcalling" folder.
 ```marksown=
cd /work/username/variantcalling
```
3.Copy the executable files needed for the class.
```marksown=
rsync -avz /work/u2499286/variantcalling/variantcallingR/vep.sh /work/username/variantcalling/variantcallingR
```
### Step 2: Modify the Analysis Executable
1. Enter vep.sh
```
vim vep.sh
```
2. Enter `:wq` to save and exit.
```
:wq
```
3. Execute the script: Enter the following command to submit the edited draft as an sbatch job:
```
sbatch vep.sh
```

3. After execution, the following files will be generated:

- **sample.HC_normed.vcf.gz**: The VCF after splitting multiallelic variants.
- **sample.HC.VEP.vcf**:  After VEP annotation, the file sample.HC.VEP.vcf_summary.html is generated first, followed by the output in VCF format.
- **sample.HC.VEP.vcf_warnings.txt**: Files containing statistical summaries and warnings after VEP annotation.
- **sample.HC.VEP.tsv, sample.HC.VEP_filtered.tsv**: The VCF format converted to TSV format, with some fields removed in the filtered version. Each line represents a variant, and different transcripts are separated by a comma (",").


## Explanation of TSV Files


### :warning:  Background information  :warning:
Since VEP takes a longer time to run the annotation, the steps below will use results that have already been processed by the teaching assistant. Please copy the TA's results first.
  ```
rsync -avz /work/u2499286/variantcalling/variantcallingR/SRR13076392_S14_L002_.HC.VEP_filtered.tsv ./
```  
    

(1) **CHROM**: The chromosome.
(2) **POS**: The position of the variant.
(3) **REF**: The reference allele.
(4) **ALT**: The alternate allele.
(5) **DP**: Sequencing depth.
(6) **Allele**: Same as ALT.
(7) **Consequence**: The effect of the variant on the alternative allele.(https://www.ensembl.org/info/genome/variation/prediction/predicted_data.html)
(8) **SYMBOL**: The official gene symbol.
(9) **Gene**: The ID of the affected gene (e.g., ENSG00000223972).
(10)**gnomADe_EAS_AF**: The allele frequency of this variant in the East Asian population in the gnomAD Exome database.
(11)**gnomADg_EAS_AF**: The allele frequency of this variant in the East Asian population in the gnomAD Genome database (if available).
(12)**CLIN_SIG**: Clinical significance records in ClinVar database.
(13)**TWB_official_SNV_indel_AF**: The allele frequency of this variant in the Taiwan Biobank.(https://www.sciencedirect.com/science/article/pii/S2090123223004058?via%3Dihub)
    
    
----------
# 生物標記物與它們的產地實作課程(六)
## 本次課程主要內容
 1. 利用VEP做annotation



#### 甚麼是annotation?
Annotation是指對生物序列（如DNA、RNA、蛋白質）進行功能標注，幫助解釋其生物意義，主要有結構資訊，用於標記基因的位置，列如exon、intron等；和功能資訊，用於預測基因的生物功能、蛋白質的作用等，這樣可以幫助我們理解結構與功能的關聯。

#### VEP介紹
VEP（Variant Effect Predictor）是由Ensembl開發的一款工具，用於分析遺傳資訊，特别是評估基因中的不同變異（如SNVs、insertion、deletion和Structural variants）對生物功能的影響，非常適合用於annotation。





### step1:在國網上建立路徑
1. 登入國網（忘記怎麼登入的人請參見[連結](https://hackmd.io/jcvG9iIiRW6DTUysi8AKug)）
2. 進入variantcallingR資料夾
```marksown=
cd /work/username/variantcalling/variantcallingR
```
3. 複製上課所需執行檔
```marksown=
rsync -avz /work/u2499286/variantcalling/variantcallingR/vep.sh /work/username/variantcalling/variantcallingR
```
### step 2 修改分析執行檔


1. 進入vep資料夾
```
vim vep.sh
```

2. 輸入`:wq`儲存離開
```
:wq
```
3. 執行script

(1)輸入以下指令，來以sbatch job的方式送出編輯完成的草稿
```
sbatch vep.sh
```


(2)若送出成功將會出現以下文字 

```Submitted batch job -------```



(3)可使用以下指令查看工作執行情況
```
sacct
```


5. 執行完成後會產生以下檔案：
- sample.HC_normed.vcf.gz：split multiallelic 後的 vcf
- sample.HC.VEP.vcf：VEP annotate 後以 vcf 的格式輸出sample.HC.VEP.vcf_summary.html
- sample.HC.VEP.vcf_warnings.txt：VEP annotate 完後的一些統計及警告的資料
- sample.HC.VEP.tsv及sample.HC.VEP_filtered.tsv：將 vcf 的格式轉換成 tsv 的格式，以及將一些的欄位刪減後的 tsv。每一行為一個 variant，若有不同 transcript 會以 "," 分隔
 
 
 ## tsv檔案講解說明
 

### :warning: <前情提要> :warning:
由於vep在執行annotation的時間較長，所以執行以下步驟時使用的都是助教已經跑出的結果，請先複製助教的結果。
```
rsync -avz /work/u2499286/variantcalling/variantcallingR/SRR13076392_S14_L002_.HC.VEP_filtered.tsv ./
```

    
1. CHROM：變異所在的染色體
2. POS:變異所在的座標
3. REF：參考資料之等位基因
4. ALT：變異後的等位基因
5. DP：測序深度
6. Allele：與ALT相同
7. Consequence：變異位點所影響之等位基因。(https://www.ensembl.org/info/genome/variation/prediction/predicted_data.html)
7. SYMBOL：基因的官方名稱。
8. Gene：受影響基因的 ID（例如，ENSG00000223972 等）。
9. gnomADe_EAS_AF：此變異在gnomAD Exome資料庫中的東亞人群等位基因頻率。
10. gnomADg_EAS_AF：此變異在gnomAD Genome資料庫中的東亞人群等位基因頻率（如果存在）。
12. CLIN_SIG：在ClinVar database中臨床意義。
13. TWB_official_SNV_indel_AF：台灣人體資料庫中此變異的等位基因頻率。(https://www.sciencedirect.com/science/article/pii/S2090123223004058?via%3Dihub)
