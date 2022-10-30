# Doraemon Himitsu Dogu Japanese semantic search

Python based Doraemon Himitsu Dogu Japanese semantic search based on Elasticsearch approximate nearest neighbor(ANN) feature.

Japanese: Elasticsearch の近似近傍探索機能を使ったドラえもんのひみつ道具自然言語検索エンジン

![](./docs/demo_v1.gif)

## Key technology

- HuggingFace
  - [sonoisa/sentence-bert-base-ja-mean-tokens-v2](https://huggingface.co/sonoisa/sentence-bert-base-ja-mean-tokens-v2)
- Elasticsearch
- Streamlit

## Dataset

I made a Himitdu Dogu dataset based on this site.
[ひみつ道具カタログ](https://www.tv-asahi.co.jp/doraemon/tool/a.html)

## Indexing phase

```mermaid
graph LR;
text-->|json形式に構造化|json
json-->|説明文|HuggingFace
json-->Elasticsaerch
HuggingFace-->|特徴ベクトル化|Elasticsaerch
```

## Search phase

```mermaid
graph LR;
Query-->|強くなる|B["HuggingFace(encoder)"]
subgraph Streamlit
    B
end
subgraph Elasticsearch
    A[multi match]
    ANN
end
B-->|"[1.2, ... 0.3]"|ANN
B-->|"kuromoji"|A
```

## How to set up

```bash
# Do in background...
$ make run-es
make run-es
es01
[+] Building 0.1s (6/6) FINISHED
 => [internal] load build definition from Dockerfile                                                                                                                           0.0s
 => => transferring dockerfile: 223B
...

$ make build-index
Get the certification for ElasticSearch
Make structured data from raw data
poetry run python doraemon_himitsu_dogu_search/preprocess.py
Run sentens vectorizer
poetry run python doraemon_himitsu_dogu_search/sentents_bert_vectorizer.py
Start BERT encode
100%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 41/41 [03:02<00:00,  4.45s/it]
End BERT encode
Start serialization as numpy file
End serialization
Run Elasticsearch indexing job
poetry run python doraemon_himitsu_dogu_search/indexer.py

$ make run-app
Get the certification for ElasticSearch
Running the web app for Doraemon himitsu dogu search
poetry run streamlit run doraemon_himitsu_dogu_search/app.py

  You can now view your Streamlit app in your browser.

  Local URL: http://localhost:8501
```


## Related Posts

- [Elasticsearchの近似近傍探索を使って、ドラえもんのひみつ道具検索エンジンを作ってみた \| 🦅 hurutoriya](https://shunyaueta.com/posts/2022-10-23-2344/) in Japanese
- [Elasticsearch 8\.4 から利用可能な従来の検索機能と近似近傍探索を組み合わせたハイブリッド検索を試す \| 🦅 hurutoriya](https://shunyaueta.com/posts/2022-10-29-2337/) in Japanese
