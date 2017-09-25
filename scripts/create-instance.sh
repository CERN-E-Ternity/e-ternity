#!/usr/bin/env bash
#
# This file is part of Invenio.
# Copyright (C) 2017 CERN.
#
# Invenio is free software; you can redistribute it
# and/or modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# Invenio is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Invenio; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
# MA 02111-1307, USA.
#
# In applying this license, CERN does not
# waive the privileges and immunities granted to it by virtue of its status
# as an Intergovernmental Organization or submit itself to any jurisdiction.

set -aex

cd /code
pip install --process-dependency-links --trusted-host github.com -Ue .[postgresql,elasticsearch2]
invenio db init
invenio db create
invenio index init
invenio index queue init
invenio demo init # loads demo data. don't do it if you don't want to
# then we want to create the location to store the records, and the location to store the archive
# for test environment, use the folder archivematica-test instead!!!
invenio files location --default records /records/
invenio files location archive /archive/
# finally, create a user and give him access to the oais APIs
invenio users create --active --password testtest test@test.com
invenio access allow archive-read user test@test.com
invenio access allow archive-write user test@test.com

