#### generate graphs from tf:

    ~/go/src/github.com/cycloidio/inframap/inframap  generate --tfstate terraform.tfstate --connections=false  | dot -Tpng > graph.png

    ~/go/src/github.com/cycloidio/inframap/inframap  generate --tfstate terraform.tfstate --raw --connections=false  | dot -Tsvg > graph.svg

note: requires `cycloidio/inframap` and go installed
