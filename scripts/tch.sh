#!/usr/bin/env bash

xrdb "$HOME/.xres/tch.xres"

urxvt &
disown

sleep ".5s"

xrdb "$HOME/.Xdefaults"