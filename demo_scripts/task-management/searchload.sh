for i in {1..100000}
do
    curl -s -XGET "localhost:9200/_search?size=10000" > /dev/null
done