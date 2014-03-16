#!/bin/sh
sed 's/timestamp="[^"]*"//g' | sed 's/user="[^"]*"//g'      | sed 's/visible="[^"]*"//g'   | sed 's/version="[^"]*"//g'   | sed 's/changeset="[^"]*"//g' | sed 's/uid="[^"]*"//g' 

               
