#defmodule MmApi.Poll do
#  use MmApi.Web, :model

#  schema "polls" do
#    field :title, :string
#    field :subtitle, :string
#    field :qa_id, :string
#    field :status, :string
#    field :desired_time, Ecto.DateTime

#    timestamps()
#  end

#  @doc""" 
#  Builds a changeset based on the `struct` and `params`.
#  """
#  def changeset(struct, params \\ %{}) do
#    struct
#    |> cast(params, [:title, :subtitle, :qa_id, :status, :desired_time])
#    |> validate_required([:title, :subtitle, :qa_id, :status])
#  end
#end
