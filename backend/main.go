package main

import (
    "fmt"
    "net/http"
)

func main() {
    mux := http.NewServeMux();
    mux.Handle("/", http.FileServer(http.Dir("./frontend/built")))
    /* mux.HandleFunc("/", */
    /*     func ( w http.ResponseWriter, r *http.Request ){ */
    /*         http.ServeFile(w, r, "./frontend/built/index.html") */
    /* }); */

    fmt.Println("Serving on port 8080...");
    err := http.ListenAndServe(":8080", mux);
    if err != nil {
        fmt.Println(err);
        return;
    };
}
