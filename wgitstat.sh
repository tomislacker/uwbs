#!/bin/bash

watch --color -tn 1 'echo ; ( git status ; echo ; echo ======================================== ; echo ; git branch -avv ) | ccze -A'

