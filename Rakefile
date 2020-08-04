# Rakefile
task :mock do
  sh "./scripts/gen-swifty-mocky-config-files.sh"
  sh "swiftymocky generate"
end

task :mockwatch do
  sh "./scripts/gen-swifty-mocky-config-files.sh"
  sh "swiftymocky generate --watch"
end