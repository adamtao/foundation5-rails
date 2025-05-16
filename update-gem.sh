#! /bin/sh

# clean old version
rm -rf bower_components
rm -rf vendor
mkdir -p vendor/assets/javascripts/vendor vendor/assets/stylesheets

# update assets
bower install
cp bower_components/modernizr/modernizr.js vendor/assets/javascripts/vendor/.
cp -R bower_components/foundation/js/foundation/ vendor/assets/javascripts/foundation/
cp -R bower_components/foundation/scss/* vendor/assets/stylesheets/

# create vendor/assets/javascripts/foundation.js (rails inclusions //=require foundation, ...)
cd vendor/assets/javascripts
echo '//= require foundation/foundation' > foundation.js
for f in foundation/*.*.js; do echo "//= require $f" | sed 's/.js//' >> foundation.js ; done

# fix broken magellan
sed -i 's/href\*=#/href*=\"#\"/g' foundation/foundation.magellan.js;

# fix broken reveal
sed -i "s/css.top = \$(window).scrollTop() - el.data('offset')/css.top = \$(root_element).scrollTop() - el.data('offset')/" foundation/foundation.reveal.js;
sed -i "s/top: \$(window).scrollTop() + el.data('css-top')/top: \$(root_element).scrollTop() + el.data('css-top')/" foundation/foundation.reveal.js;

# echo "Now update version.rb"

cd -
