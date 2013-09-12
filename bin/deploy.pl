#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

use Dancer;
use Dancer::Plugin::DBIC;

schema->deploy;
