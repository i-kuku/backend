defmodule IKuku.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  create table(:user) do
    add :first_name, :string
    add :last_name, :string
    add :phone_number, :string
    add :alternative_phone_number, :string
    add :password_hash, :string
    add :recovery_phone_number, :string
    add :role, :string
  end

  create unique_index(:users, [:phone_number])
  create unique_index(:users, [:alternative_phone_number])
end
