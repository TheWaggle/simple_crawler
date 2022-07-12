defmodule Test do
  def add(n) do
    if n == 0 do
      IO.puts("変数n = 0")
      IO.inspect(0)
    else
      IO.puts("変数n = #{n}")
      IO.inspect(add(n - 1) + n)
    end
  end

  def get do
    s = IO.gets("ドメイン入力")
    IO.inspect(s)
  end
end
