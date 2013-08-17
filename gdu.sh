#!/bin/bash
#
# Google Drive Uploader bash shell version
#
# usage: ./gdu.sh yourfile
#
# more reference on https://developers.google.com/gdata/docs/auth/overview
# https://developers.google.com/accounts/docs/OAuth2InstalledApp
# https://developers.google.com/accounts/docs/OAuth2Login
# https://developers.google.com/drive/
# Quickstart page.
#
#
# Rev 1.0
# 2013/08/17
# Copyright 2013 Jacky Shih <iluaster@gmail.com>
#
# Licensed under the GNU General Public License, version 2.0 (GPLv2)
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 as published
# by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
# NON INFRINGEMENT.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
#


filename="$1"
client_id="<YOUR_CLIENT_ID>"            # put your client id here.
client_secret="<YOUR_CLIENT_SECRET>"    # put your client secret here.
file_title="$1"
content_type="<Your file content type>" # put your file content type here. e.g. "text/plain", "image/jpeg"

# Compute total content_length
file_name_length=`echo -n "$1" | wc -c`
file_size=`ls -l "$1" | awk '{print $5}'`
content_length=$((137+$file_name_length+$file_size)) # 137 is fixed post data

echo 'Please enter this URL in your web browser:'
echo "https://accounts.google.com/o/oauth2/auth?client_id=$client_id&response_type=code&scope=https://www.googleapis.com/auth/drive&redirect_uri=urn:ietf:wg:oauth:2.0:oob"
echo -n 'Enter your google code: '
read code

# Get access token"
echo -e "POST /o/oauth2/token HTTP/1.1\nHost: accounts.google.com\nContent-Length: 258\nContent-Type: application/x-www-form-urlencoded\n\ncode=$code&client_id=$client_id&client_secret=$client_secret&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code&Connection: close" | nssl accounts.google.com 443 > access_token.txt
access_token=` grep 'access_token' access_token.txt | cut -d "\"" -f 4 `
echo "Your token is $access_token"


# Upload Your file
(
 echo "POST /upload/drive/v2/files?uploadType=multipart HTTP/1.1"
 echo "Host: www.googleapis.com"
 echo "Authorization: AuthSub token=\"$access_token\""
 echo "Content-Type: multipart/related; boundary=\"foo_bar_baz\""
 echo "Content-Length: $content_length"
 echo "Connection: close"
 echo ""
 echo "--foo_bar_baz"
 echo "Content-Type: application/json; charset=UTF-8"
 echo ""
 echo "{"
 echo "  \"title\": \"$file_title\""
 echo "}"
 echo ""
 echo "--foo_bar_baz"
 echo "Content-Type: $content_type"
 echo ""
 exec 4<> "$filename"   #fd 5 might cause problems.   http://0rz.tw/ChVJB
 cat <&4
 exec 4>&-
 echo ""
 echo "--foo_bar_baz--"
 ) | nssl www.googleapis.com 443 > upload_file_detail.txt
 echo "Transfer Completed!!"
