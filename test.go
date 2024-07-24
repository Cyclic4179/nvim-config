package main

import (
	"fmt"
	"testing"
)

func IntMin(a, b int) int {
    if a < b {
        return a
    }
    return b
}


func TestIntMinBasic(t *testing.T) {
    ans := IntMin(2, -2)
    if ans != -2 {
        fmt.Printf("IntMin(2, -2) = %d; want -2", ans)
    } else {
        fmt.Println("I'm good!")
    }
}
