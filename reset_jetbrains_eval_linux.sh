#!/bin/sh

JB_PRODUCTS="IntelliJIdea PhpStorm GoLand PyCharm WebStorm RubyMine"
jb_products="goland phpstorm pycharm webstorm rubymine intellijidea"

for PRD in $JB_PRODUCTS; do
	rm -v ~/.config/JetBrains/${PRD}*/options/other.xml >&1 2>/dev/null
	rm -rfv ~/.config/JetBrains/${PRD}*/eval 
done

for prd in $jb_products; do
        rm -rvf	~/.java/.userPrefs/jetbrains/${prd} >&1 2>/dev/null
done

echo 'done'
