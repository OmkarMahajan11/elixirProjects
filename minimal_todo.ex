defmodule MinimalTodo do

  # ask for file name
  # open and read the file
  # parse the data
  # ask for user command
  # (read todo, add todo, delete todo, load file and save file)

  def start do
    IO.gets("Name of .csv to load: ")
    |> String.trim()
    |> read()
    |> parse()
    |> get_command()
  end

  def get_command(data) do
    prompt = """
    Type the first letter of the command
    R)ead Todos     A)dd Todos    D)elete Todos   L)oad a .csv    S)ave a .csv
    """
    command = IO.gets(prompt)
      |> String.trim()
      |> String.downcase()

    case command do
      "r" -> read(data)
    end
  end

  def read(filename) do
    case File.read(filename) do
      {:ok, body} -> body
      {:error, reason} ->
        IO.puts ~s{could not open "#{filename}"}
        IO.puts ~s{error: #{:file.format_error(reason)}}
        start()
    end
  end

  def parse(body) do
    [header | lines] = String.split(body, ~r{(\r\n|\r|\n)})
    titles = tl String.split(header, ",")
    parse_lines(lines, titles)
  end

  def parse_lines(lines, titles) do
    Enum.reduce(lines, %{}, fn line, built ->
      [name | fields] = String.split(line, ",")
      if Enum.count(fields) == Enum.count(titles) do
        line_data = Enum.zip(titles, fields)
          |> Enum.into(%{})
        Map.merge(built, %{name => line_data})
      else
        built
      end
    end)
  end

  def show_todos(data, next_command?\\true) do
    items = Map.keys(data)
    IO.puts "You have following todos:\n"
    Enum.each(items,&(IO.puts &1))
    IO.puts "\n"
    if next_command? do
      get_command(data)
    end
  end
end
