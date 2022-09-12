defmodule Bonfire.Data.Identity.User do
  @moduledoc """
  A persona. A person (account) may have more than one user, but this
  is not exposed publicly (except to local instance administrators),
  so it is as if they are different people.
  """

  use Pointers.Virtual,
    otp_app: :bonfire_data_identity,
    table_id: "5EVSER1S0STENS1B1YHVMAN01D",
    source: "bonfire_data_identity_user"

  alias Bonfire.Data.Identity.User
  alias Pointers.Changesets

  virtual_schema do
  end

  def changeset(user \\ %User{}, params), do: Changesets.cast(user, params, [])
end

defmodule Bonfire.Data.Identity.User.Migration do
  use Ecto.Migration
  import Pointers.Migration
  alias Bonfire.Data.Identity.User

  # create_user_view/{0,1}

  defp make_user_view() do
    quote do
      require Pointers.Migration
      Pointers.Migration.create_virtual(Bonfire.Data.Identity.User)
    end
  end

  defmacro create_user_view(), do: make_user_view()

  # drop_user_view/0

  def drop_user_view(), do: drop_virtual(User)

  # migrate_user/{0,1}

  defp mu(:up), do: make_user_view()

  defp mu(:down) do
    quote do: Bonfire.Data.Identity.User.Migration.drop_user_view()
  end

  defmacro migrate_user() do
    quote do
      if Ecto.Migration.direction() == :up,
        do: unquote(mu(:up)),
        else: unquote(mu(:down))
    end
  end

  defmacro migrate_user(dir), do: mu(dir)
end
