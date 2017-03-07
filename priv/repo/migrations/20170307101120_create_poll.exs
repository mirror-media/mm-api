defmodule PollApi.Repo.Migrations.CreatePoll do
  use Ecto.Migration

  def change do
    create table(:polls) do
      add :title, :string
      add :subtitle, :string
      add :qa_id, :string
      add :status, :string
      add :desired_time, :datetime

      timestamps()
    end

  end
end
