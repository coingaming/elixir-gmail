ExUnit.start

defmodule Gmail.LabelTest do

  use ExUnit.Case
  import Mock

  setup do

    access_token = "xxx-xxx-xxx"
    access_token_rec = %{access_token: access_token}

    label_id = "Label_22"
    label_name = "Cool Label"
    label_type = "user"

    label = %{
      "id" => label_id,
      "name" => label_name,
      "type" => label_type
    }

    labels = %{"labels" => [label]}

    expected_result = %Gmail.Label{
      id: label_id,
      name: label_name,
      type: label_type
    }

    expected_results = [expected_result]

    errors = [
      %{"message" => "Error #1"},
      %{"message" => "Error #2"}
    ]

    {:ok, %{
        access_token: access_token,
        access_token_rec: access_token_rec,
        label_id: label_id,
        label_name: label_name,
        label: label,
        labels: labels,
        expected_result: expected_result,
        expected_results: expected_results,
        label_not_found: %{"error" => %{"code" => 404}},
        four_hundred_error: %{"error" => %{"code" => 400, "errors" => errors}}
      }}
  end

  test "creates a new label", context do
    with_mock Gmail.HTTP, [ post: fn _at, _url, _data -> { :ok, context[:label] } end] do
      with_mock Gmail.OAuth2, [ get_config: fn -> context[:access_token_rec] end ] do
        {:ok, label} = Gmail.Label.create(context[:label_name])
        assert context[:expected_result] == label
        assert called Gmail.OAuth2.get_config
        assert called Gmail.HTTP.post(context[:access_token],
          Gmail.Base.base_url <> "users/me/labels", %{"name" => context[:label_name]})
      end
    end
  end

  # test "deletes a label" do

  # end

  test "lists all labels", context do
    with_mock Gmail.HTTP, [ get: fn _at, _url -> { :ok, context[:labels] } end] do
      with_mock Gmail.OAuth2, [ get_config: fn -> context[:access_token_rec] end ] do
        {:ok, labels} = Gmail.Label.list
        assert context[:expected_results] == labels
        assert called Gmail.OAuth2.get_config
        assert called Gmail.HTTP.get(context[:access_token], Gmail.Base.base_url <> "users/me/labels")
      end
    end
  end

  # test "updates a label" do

  # end

  test "gets a label", context do
    with_mock Gmail.HTTP, [ get: fn _at, _url -> { :ok, context[:label] } end] do
      with_mock Gmail.OAuth2, [ get_config: fn -> context[:access_token_rec] end ] do
        {:ok, label} = Gmail.Label.get(context[:label_id])
        assert context[:expected_result] == label
        assert called Gmail.OAuth2.get_config
        assert called Gmail.HTTP.get(context[:access_token], Gmail.Base.base_url <> "users/me/labels/" <> context[:label_id])
      end
    end
  end

  test "reports :not_found for a thread that doesn't exist", context do
    with_mock Gmail.HTTP, [ get: fn _at, _url -> { :ok, context[:label_not_found] } end] do
      with_mock Gmail.OAuth2, [ get_config: fn -> context[:access_token_rec] end ] do
        :not_found = Gmail.Label.get(context[:label_id])
        assert called Gmail.OAuth2.get_config
        assert called Gmail.HTTP.get(context[:access_token], Gmail.Base.base_url <> "users/me/labels/" <> context[:label_id])
      end
    end
  end

  test "handles a 400 error from the API", context do
    with_mock Gmail.HTTP, [ get: fn _at, _url -> { :ok, context[:four_hundred_error] } end] do
      with_mock Gmail.OAuth2, [ get_config: fn -> context[:access_token_rec] end ] do
        {:error, "Error #1"} = Gmail.Label.get(context[:label_id])
        assert called Gmail.OAuth2.get_config
        assert called Gmail.HTTP.get(context[:access_token], Gmail.Base.base_url <> "users/me/labels/" <> context[:label_id])
      end
    end
  end

  # test "patches a label" do

  # end

end
