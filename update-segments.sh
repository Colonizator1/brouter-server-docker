curl http://brouter.de/brouter/segments4/ | sed '/rd5/!d' | sed 's/<a href="/http:\/\/brouter.de\/brouter\/segments4\//' | sed 's/".*//' | xargs -n5 -P3 wget -N -P ./data/segments