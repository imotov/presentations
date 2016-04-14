for i in {1..100000}
do
    curl -s -XPOST "localhost:9200/_bulk" --data-binary "@bulk.txt"; echo
done