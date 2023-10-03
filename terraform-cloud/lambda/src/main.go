package main

import (
    "context"
    "fmt"
    "github.com/aws/aws-lambda-go/lambda"
)

func handler(ctx context.Context) (string, error) {
    message := "Hello, World!"
    fmt.Println(message)
    return message, nil
}

func main() {
    lambda.Start(handler)
}
