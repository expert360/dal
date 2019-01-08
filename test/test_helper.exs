ExUnit.start()

"./test/support/**/*.exs"
|> Path.wildcard
|> Enum.each(fn(file) ->
  Code.require_file "../#{file}", __DIR__
end)

Code.require_file "dal_test_case.exs", __DIR__
