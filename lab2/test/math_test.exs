defmodule MathTest do
  use ExUnit.Case, async: true
  alias Math.{Matrix, Element}

  describe "has_absolute_diagonal?/1" do
    @tag :success
    test "return :ok" do
      matrix = %Matrix{
        rows: 2,
        columns: 2,
        data: [
          [3,1],
          [3,-4]
        ]
      }

      expected =[
        %Element{row: 0, col: 0, val: 3},
        %Element{row: 1, col: 1, val: -4}
      ]

      assert {:ok, actual} = Math.has_absolute_diagonal?(matrix)

      assert MapSet.new(expected) == MapSet.new(actual)
    end
  end

  @tag :fail
    test "FAIL reason: can't create diagonal" do
      matrix = %Matrix{
        rows: 2,
        columns: 2,
        data: [
          [3,1],
          [7,-4]
        ]
      }

      expected_reason = "Can't create main diagonal from absolute elements"

      assert {:fail, actual_reason} = Math.has_absolute_diagonal?(matrix)

      assert expected_reason == actual_reason
    end

    @tag :fail
    test "FAIL reason: failed at row" do
      matrix = %Matrix{
        rows: 2,
        columns: 2,
        data: [
          [3,1],
          [4,-4]
        ]
      }

      row_idx = 1
      expected_reason = "Failed at row_idx = #{row_idx}. Not an absolute element"

      assert {:fail, actual_reason} = Math.has_absolute_diagonal?(matrix)

      assert expected_reason == actual_reason
    end
end




"""
@deprecated "made by mistake"
defmodule MathTestDepricated do
  use ExUnit.Case, async: true
  alias Math.{Matrix, Element}

  describe "get_max_elements_for_each_row/1" do
    @tag :success
    test " returns list" do
      matrix = %Math.Matrix{rows: 2, columns: 2, data: [[1, 2], [3, 4]]}
      expected = [%Math.Element{row: 0, col: 1, val: 2}, %Math.Element{row: 1, col: 1, val: 4}]

      actual = Math.get_max_elements_for_each_row(matrix)

      assert actual == expected
    end
  end

  @tag :success
  describe "elements_dominant?/2" do
    test "returns true" do
      matrix = %Math.Matrix{rows: 3, columns: 3, data: [[1, 2, 0], [3, 4, 1], [0, 0, 8]]}

      max_elements = [
        %Math.Element{row: 0, col: 1, val: 2},
        %Math.Element{row: 1, col: 1, val: 4},
        %Math.Element{row: 2, col: 2, val: 8}
      ]

      expected = true

      actual = Math.elements_dominant?(max_elements, matrix)

      assert actual == expected
    end

    @tag :fail
    test "returns false" do
      matrix = %Math.Matrix{rows: 3, columns: 3, data: [[1, 2, 0], [3, 4, 1], [7, 7, 8]]}

      max_elements = [
        %Math.Element{row: 0, col: 1, val: 2},
        %Math.Element{row: 1, col: 1, val: 4},
        %Math.Element{row: 2, col: 2, val: 8}
      ]

      expected = false

      actual = Math.elements_dominant?(max_elements, matrix)

      assert actual == expected
    end
  end

  describe "diagonal_dominant?/1" do
    @tag :success
    test "return map without double elements in a row" do
      dominant_elements = [
        %Math.Element{row: 0, col: 1, val: 7},
        %Math.Element{row: 1, col: 0, val: 7},
        %Math.Element{row: 2, col: 2, val: 7}
      ]

      expected = %{1 => 0, 0 => 1, 2 => 2}

      actual = Math.diagonal_dominant?(dominant_elements)

      assert actual == expected
    end

    @tag :fail
    test "return false without double elements in a row" do
      # |_x_
      # |x__
      # |_x_

      dominant_elements = [
        %Math.Element{row: 0, col: 1, val: 7},
        %Math.Element{row: 1, col: 0, val: 7},
        %Math.Element{row: 2, col: 1, val: 7}
      ]

      expected = false

      actual = Math.diagonal_dominant?(dominant_elements, 3)

      assert actual == expected
    end

    @tag :success
    test "n.1 return map with! double elements in a row" do
      dominant_elements = [
        %Math.Element{row: 0, col: 1, val: 7},
        %Math.Element{row: 1, col: 0, val: 7},
        %Element{row: 1, col: 1, val: 7},
        %Math.Element{row: 2, col: 2, val: 7}
      ]

      expected = %{1 => 0, 0 => 1, 2 => 2}

      actual = Math.diagonal_dominant?(dominant_elements)

      assert actual == expected
    end

    @tag :fail
    test "n.1 return false with! double elements in a row" do
      dominant_elements = [
        %Math.Element{row: 0, col: 1, val: 7},
        %Math.Element{row: 0, col: 0, val: 7},
        %Math.Element{row: 1, col: 0, val: 7},
        %Math.Element{row: 2, col: 1, val: 7}
      ]

      expected = false

      actual = Math.diagonal_dominant?(dominant_elements, 3)

      assert actual == expected
    end

    @tag :success
    test "n.2 return map with! double elements in a row" do
      dominant_elements = [
        %Math.Element{row: 0, col: 0, val: 7},
        %Math.Element{row: 0, col: 2, val: 7},
        %Math.Element{row: 1, col: 1, val: 7},
        %Math.Element{row: 2, col: 2, val: 7}
      ]

      expected = %{0 => 0, 1 => 1, 2 => 2}

      actual = Math.diagonal_dominant?(dominant_elements)

      assert actual == expected
    end

    @tag :fail
    test "n.2 return false with! double elements in a row" do
      # |xx__
      # |x_x_
      # |x__x
      # |__x_
      dominant_elements = [
        %Math.Element{row: 0, col: 0, val: 7},
        %Math.Element{row: 0, col: 1, val: 7},
        %Math.Element{row: 1, col: 0, val: 7},
        %Math.Element{row: 1, col: 2, val: 7},
        %Math.Element{row: 2, col: 0, val: 7},
        %Math.Element{row: 2, col: 3, val: 7},
        %Math.Element{row: 3, col: 2, val: 7}
      ]

      expected = false

      actual = Math.diagonal_dominant?(dominant_elements, 4)

      assert actual == expected
    end

    @tag :success
    test "n.3 return map with! double elements in a row" do
      # |xx__
      # |x___
      # |__x_
      # |x__x

      dominant_elements = [
        %Element{row: 0, col: 0, val: 2},
        %Element{row: 0, col: 1, val: 7},
        %Element{row: 1, col: 0, val: 7},
        %Element{row: 2, col: 2, val: 7},
        %Element{row: 3, col: 0, val: 7},
        %Element{row: 3, col: 3, val: 7}
      ]

      expected = %{1 => 0, 0 => 1, 2 => 2, 3 => 3}

      actual = Math.diagonal_dominant?(dominant_elements)

      assert actual == expected
    end
  end

  test "full path success" do
    # |x_x__
    # |_xx__
    # |__x_x
    # |x__x_
    # |___xx

    matrix = %Matrix{
      rows: 5,
      columns: 5,
      data: [
        [7, 0, 7, 0, 0],
        [0, 7, 7, 0, 0],
        [0, 0, 7, 0, 7],
        [7, 0, 0, 7, 0],
        [0, 0, 0, 7, 7]
      ]
    }

    # dominant_elements =
    #   [
    #     %Element{row: 0,col: 0,val: 7}, %Element{row: 0,col: 2,val: 7},
    #     %Element{row: 1,col: 1, val: 7},%Element{row: 1,col: 2, val: 7},
    #     %Element{row: 2, col: 2, val: 7},%Element{row: 2, col: 4, val: 7},
    #     %Element{row: 3,col: 0,val: 7}, %Element{row: 3,col: 3,val: 7},
    #     %Element{row: 4,col: 3, val: 7},%Element{row: 4,col: 4, val: 7}
    #   ]

    # expected = %{0=>0, 1=>1, 2=>2, 3=>3, 4=>4} - maybe, but another solution was chosen.

    max_els =
      matrix
      |> Math.get_max_elements_for_each_row()

    assert Math.elements_dominant?(max_els, matrix)

    dominant_els = max_els

    actual =
      dominant_els
      |> Math.diagonal_dominant?()

    assert map_size(actual) == matrix.rows

    assert actual
           |> Map.values()
           |> Enum.uniq()
           |> length() == matrix.rows

    assert actual
           |> Enum.all?(fn {r, c} ->
             Enum.any?(dominant_els, fn
               %Element{row: ^r, col: ^c} -> true
               _ -> false
             end)
           end)
  end
end
"""
