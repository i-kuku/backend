defmodule Ikuku.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :phone_number, :string
    field :recovery_phone_number, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    field :role, Ecto.Enum, values: [:admin, :farmer, :farm_manager, :extension_farmer]

    timestamps()
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:first_name, :last_name, :password, :phone_number])
    |> validate_required([:first_name, :last_name, :phone_number])
    |> validate_field_formats()
    |> unique_constraint(:phone_number)
    |> _hash_password()
  end

  def create_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:role_id])
    |> validate_required([:role_id])
  end

  def validate_field_formats(changeset) do
    changeset
    |> validate_format(:phone_number, ~r/^\+?\d{9,12}+$/,
      message: "Phone number doesn't look right"
    )
    |> validate_format(:first_name, ~r/^['a-zA-Z ]{3,}+$/,
      message: "Name should be at least 3 characters and must be letters of alphabet"
    )
    |> validate_format(:last_name, ~r/^['a-zA-Z ]{3,}+$/,
      message: "Name should be at least 3 characters and must be letters of alphabet"
    )
  end

  defp _hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
