defmodule SimpleCrawler do
  def get_url(url) do
    html = HTTPoison.get!(url)

    Floki.parse_document!(html.body)
    |> Floki.find("a")
    |> Floki.attribute("href")
  end

  def get_url_list(url_list, domain) do
    list =
    for url <- url_list do
      get_url(url)
      |> Enum.filter(& String.starts_with?(&1, domain))
    end

    List.flatten(list)
  end

  def check_url(url_list, domain) do
    all_url = Enum.uniq(url_list ++ get_url_list(url_list, domain))
    if Enum.count(all_url) >= 100 do
      IO.puts("100件を満たしました。\n")
      all_url
    else
      if all_url == url_list do
        IO.puts("全てのページを取得しました。\n")
        all_url
      else
        IO.puts("処理中・・・\n")
        check_url(all_url, domain)
      end
    end

    # わかりやすくリファクタリングした内容
    # cond do
    #   Enum.count(all_url) >= 100 ->
    #     IO.puts("100件を満たしました。\n")
    #     all_url

    #   all_url == url_list ->
    #     IO.puts("全てのページを取得しました。\n")
    #     all_url

    #   true ->
    #     IO.puts("処理中・・・\n")
    #     check_url(all_url, domain)
    # end
  end

  def get_page_text(url_list) do
    for url <- url_list do
      html = HTTPoison.get!(url)
      text =
        Floki.parse_document!(html.body)
        |> Floki.find("body")
        |> Floki.text()
        |> String.replace([" "], "")

      "#{url}\n#{text}\n\n"
    end
  end

  def file_write(data, file_name) do
    File.open!(file_name, [:write])
    |> IO.binwrite(data)
  end

  def main do
    url = user_input("URL を入力してください。\n")
    file_name = user_input("URL とテキスト情報を出力するファイル名を拡張子付きで入力してください。\n")
    domain = get_domain(url)

    check_url([url], domain)
    |> get_page_text()
    |> file_write(file_name)
  end

  def user_input(display_value) do
    IO.gets(display_value)
    |> String.replace("\n", "")
  end

  def get_domain(url) do
    [means_commuication, _, domain | _] = String.split(url, "/")
    "#{means_commuication}//#{domain}"
  end
end
