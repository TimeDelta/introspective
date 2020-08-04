# Rakefile
task :mock do
  sh "./gen-swifty-mocky-config-files.sh"
  sh "swiftymocky generate"
end

task :mockwatch do
  sh "./gen-swifty-mocky-config-files.sh"
  sh "swiftymocky generate --watch"
end