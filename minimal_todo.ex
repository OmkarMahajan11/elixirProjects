defmodule MinimalTodo do

  # ask for file name
  # open and read the file
  # parse the data
  # ask for user command
  # (read todo, add todo, delete todo, load file and save file)

  def start() do
    input = IO.gets("Would you like to create a new .csv? (y/n)\n")
      |> String.trim()
    if input == "y" do
      create_initial_todo() |> get_command
    else
      load_csv()
    end
  end

  def create_header(headers) do
    case IO.gets("Add a field: ") |> String.trim() do
      "" -> headers
      header -> create_header([header | headers])
    end
  end

  def create_headers() do
    IO.puts "What data should each todo have? "
    <> "Enter field names one by one and an empty "
    <> "line when you are done.\n"
    create_header([])
  end

  def create_initial_todo() do
    titles = create_headers()
    name = get_item_name(%{})
    fields = Enum.map(titles, &field_from_user(&1))
    IO.puts ~s{New todo "#{name} added"}
    %{name => Enum.into(fields, %{})}
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
      "r" -> show_todos(data)
      "a" -> add_todo(data)
      "d" -> delete_todo(data)
      "l" -> load_csv()
      "s" -> save_csv(data)
      "q" -> "Goodbye!"
      _ -> get_command(data)
    end
  end

  def add_todo(data) do
    # get name of todo
    name = get_item_name(data)
    # get titles
    titles =  get_fields(data)
    # get field values form user
    fields = Enum.map(titles, fn field -> field_from_user(field) end)
    # merge into data
    new_todo = %{name => Enum.into(fields, %{})}
    IO.puts "New todo added"
    new_data = Map.merge(data, new_todo)
    get_command(new_data)
  end

  def delete_todo(data) do
    todo = IO.gets("Which todo do u want to delete?")
      |> String.trim()
    if Map.has_key?(data, todo) do
      IO.puts "OK"
      new_map = Map.drop(data, [todo])
      IO.puts ~s{Deleted "#{todo}"}
      get_command(new_map)
    else
      IO.puts "No such todo"
      show_todos(data, false)
      delete_todo(data)
    end
  end

  def field_from_user(name) do
    field = IO.gets("#{name}: ") |> String.trim()
    {name, field}
  end

  def get_item_name(data) do
    name = IO.gets("Enter the name of todo: ")
      |> String.trim()
    if Map.has_key?(data, name) do
      IO.puts "Already exists"
      get_item_name(data)
    else
      name
    end
  end

  def get_fields(data) do
    data[hd Map.keys data] |> Map.keys()
  end

  def load_csv() do
    IO.gets("Name of .csv to load: ")
    |> String.trim()
    |> read()
    |> parse()
    |> get_command()
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

  def read(filename) do
    case File.read(filename) do
      {:ok, body} -> body
      {:error, reason} ->
        IO.puts ~s{could not open "#{filename}"}
        IO.puts ~s{error: #{:file.format_error(reason)}}
        start()
    end
  end

  def prepare_csv(data) do
    headers = ["item" | get_fields data]
    items = Map.keys(data)
    item_rows = Enum.map(items, fn item ->
      [item | Map.values(data[item])]
    end)
    rows = [headers | item_rows]
    row_strings = Enum.map(rows, &Enum.join(&1, ","))
    Enum.join(row_strings, "\n")
  end

  def save_csv(data) do
    filename = IO.gets "Name of the .csv file to save: "
      |> String.trim()
    filedata = prepare_csv(data)
    case File.write(filename, filedata) do
      :ok ->
        IO.puts "CSV saved"
        get_command(data)
      {:error, reason} ->
        IO.puts "Could not save file: #{filename}"
        IO.puts "#{:file.format_error(reason)}"
        get_command(data)
    end
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
