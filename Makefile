# Target source file
SRC=doraemon_himitsu_dogu_search

.PHONY: lint
lint:
	@echo "Run Linter"
	poetry run flake8 $(SRC)
	poetry run black $(SRC) --check
	poetry run mypy $(SRC)
	poetry run isort $(SRC) --check --profile black

.PHONY: fmt
fmt:
	@echo "Run formatter"
	poetry run black $(SRC)
	poetry run isort $(SRC) --profile black

.PHONY: run-es
run-es:
	@docker rm es01
	@docker build --tag=es .
	@docker run --name es01 --net elastic -p 9200:9200 -p 9300:9300 -it -v /usr/share/elasticsearch/data es
	@echo "Get the certification for ElasticSearch"
	@docker cp es01:/usr/share/elasticsearch/config/certs/http_ca.crt .

.PHONY: build-index
build-index:
	@echo "Make structured data from raw data"
	poetry run python $(SRC)/preprocess.py
	@echo "Run sentens vectorizer"
	poetry run python $(SRC)/sentents_bert_vectorizer.py
	@echo "Run Elasticsearch indexing job"
	poetry run python $(SRC)/indexer.py

.PHONY: es-info
es-info:
	@echo "Show the running Elasticsearch info"
	curl --cacert http_ca.crt -u elastic:elastic https://localhost:9200

.PHONY: run-app
run-app:
	@echo "Running the web app for Doraemon himitsu dogu search"
	poetry run streamlit run $(SRC)/app.py