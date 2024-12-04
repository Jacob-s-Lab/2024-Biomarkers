## Homework 3
### Assignment link:
https://cool.ntu.edu.tw/courses/42564/quizzes
### Due date: 2024/12/11 11:59

---------
:::warning
### Firstly: 
#### You need to have the vep.vcf files from S14, S15, and S16 annotated after running Mutect2.

:::

### vep.vcf file
#### The structure of a VCF file: header section + variant section.
1. Header: Contains the description of the file format, data information, and details about the samples and variants. These headers help us understand the structure of the subsequent data and the specific meaning of each field.

2. Variant: Contains detailed information about all the variants, with each row representing a variant, arranged according to the format defined in the header. Typically includes:

- CHROM: Chromosome number.
- POS: Position of the variant.
- ID: Unique identifier of the variant, shown as . if not available.
- REF: Reference allele in the genome.
- ALT: Alternate allele, such as T. If there are multiple variants, they can be separated by commas.
- QUAL: Quality score for the variant.
- FILTER: Indicates whether the variant passes filter criteria (PASS indicates passed, or it may be labeled with a specific filter name).
- INFO: A field that contains additional information. The results from VEP are usually found here, with annotations presented in key-value pairs.

![截圖 2024-11-30 晚上8.37.16](https://hackmd.io/_uploads/BJeMvYdQkx.png)

### VEP calculated consequence
The Ensembl Variant Effect Predictor (VEP) predicts the effect of each allele on different transcripts based on the position and properties of the variant. These types of effects are defined by Sequence Ontology (SO) and are classified according to their potential impact on gene function.

![截圖 2024-11-06 上午11.51.45](https://hackmd.io/_uploads/HJ9mwKSm1e.png)
![截圖 2024-11-28 下午2.07.00](https://hackmd.io/_uploads/r19auFHQye.png)
link:
https://asia.ensembl.org/info/genome/variation/prediction/predicted_data.html

### `grep` Tutorial

1. `grep` is a powerful command-line tool used to search for specific strings or patterns in a file.
2. The unit of search for `grep` is a line. This means that no matter how many times the keyword appears in that line, `grep` will count the entire line as a single match.
```markdown=
# Basic Usage of grep
grep "keyword" <filename>

# grep with Count Functionality
grep -c "keyword" <filename>      # or
grep "keyword" <filename>|wc      # The full name of 'wc' is "word count", but it does more than just count words. It can also count the number of lines, characters, and words in a file.
    

# Searching for Multiple Keywords with grep
grep "keyword1" <filename>|grep "keyword2"

# Output grep Results as tsv File
grep "keyword" <filename> | awk -F'\t' '{OFS="\t"; print $0}' > output.tsv
    
#The pipe symbol (|) means to pass the result of the first step to the command on the right of the | symbol.
```
link:
https://useast.ensembl.org/info/docs/tools/vep/script/vep_tutorial.html

------------------------------
## 作業（三）
### 作業連結: 
https://cool.ntu.edu.tw/courses/42564/quizzes
### Due date: 2024/12/11 11:59

----------------

:::warning

### 前情提要：
#### 需要先有 S14, S15, S16 Mutect2 做完 annotation 的 vep.vcf 檔

:::

### vep.vcf 檔案
#### vcf 檔案結構: header 部分 ＋ variant 部分
1. header：包含文件格式的說明、data 的信息，以及關於 sample 和 variant 的細節。這些 header 幫助我們理解後續 data 的結構和每一個欄位的具體含義。
2. variant：包含了所有 variant 的具體資訊，每行代表一個 variant，並按照 Header 中定義的格式進行排列。通常包含：
- CHROM
- POS
- ID：變異的唯一標識符，如果沒有則顯示為 .。
- REF：參考基因組中的等位基因。
- ALT：變異的替換等位基因，例如 T。如果有多個變異，可以用逗號分隔。
- QUAL
- FILTER：表示該變異是否通過 filter 標準，PASS 表示通過，或者標識為特定 filter 的名稱。
- INFO：這是包含額外資訊的欄位，VEP 的結果通常會在這裡，註釋資訊以鍵值對的形式出現。
![截圖 2024-11-30 晚上8.37.16](https://hackmd.io/_uploads/BJeMvYdQkx.png)



### VEP calculated consequence
Ensembl 的 Variant Effect Predictor（VEP）根據 variant 的位置和特性，預測每個等位基因對不同 transcript 的影響。這些影響類型由 Sequence Ontology（SO）定義，並按照對基因功能的潛在影響程度進行分類。
![截圖 2024-11-06 上午11.51.45](https://hackmd.io/_uploads/HJ9mwKSm1e.png)
![截圖 2024-11-28 下午2.07.00](https://hackmd.io/_uploads/r19auFHQye.png)


link:
https://asia.ensembl.org/info/genome/variation/prediction/predicted_data.html

### `grep`教學
1. `grep` 是一個強大的命令行工具，用於在文件中搜尋特定的字符串或模式。
2. `grep`搜尋的單位是行，也就是說，不論該行中匹配的關鍵字出現了多少次，`grep` 都只會將這一行列為一個匹配的結果。

```markdown=
# grep 的基本用法
grep "keyword" <filename>

# grep 並加上計算的功能
grep -c "keyword" <filename>      #或
grep "keyword" <filename>|wc      # wc 的全名是 "word count"，但它不僅僅是計算字數，還可以計算行數、字元數和字數等信息。
    

# grep 同時搜尋多個關鍵字
grep "keyword1" <filename>|grep "keyword2"

# 將結果輸出為 tsv 檔
grep "keyword" <filename> | awk -F'\t' '{OFS="\t"; print $0}' > output.tsv
    
#"|"管道符號 (|) 的意思為將第一步的結果傳到"|"符號的右邊
```

link:
https://useast.ensembl.org/info/docs/tools/vep/script/vep_tutorial.html
