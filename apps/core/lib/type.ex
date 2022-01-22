defmodule Core.Type do
  @type coordinates :: %{
          x: non_neg_integer(),
          y: non_neg_integer()
        }
  @type size :: %{
          width: pos_integer(),
          height: pos_integer()
        }
end
