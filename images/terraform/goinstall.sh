#!/bin/bash
go get -a -ldflags '-s -w' -installsuffix cgo "$@"