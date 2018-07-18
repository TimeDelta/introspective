# Rakefile
task :mock do
  sh "./gen-swifty-mocky-config-files.sh"
  sh "Pods/Sourcery/bin/Sourcery.app/Contents/MacOS/Sourcery --config mocky.yml"
end

task :mockwatch do
  sh "./gen-swifty-mocky-config-files.sh"
  sh "Pods/Sourcery/bin/Sourcery.app/Contents/MacOS/Sourcery --config mocky.yml --watch"
end