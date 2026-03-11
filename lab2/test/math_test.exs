defmodule MathTest do
  use ExUnit.Case, async: true

  test "get_max_elements_for_each_row/1 returns list" do
    matrix = %Math.Matrix{rows: 2, columns: 2, data: [[1,2],[3,4]]}
    expect = [%Math.Element{row: 0,col: 1,val: 2}, %Math.Element{row: 1,col: 1, val: 4}]

    actual = Math.get_max_elements_for_each_row(matrix)

    assert actual == expect

  end

  test "elements_dominant?/2 returns true" do
    matrix = %Math.Matrix{rows: 3, columns: 3, data: [[1,2,0],[3,4,1],[0,0,8]]}
    max_elements = [%Math.Element{row: 0,col: 1,val: 2}, %Math.Element{row: 1,col: 1, val: 4}, %Math.Element{row: 2,col: 2, val: 8}]

    expect = true

    actual = Math.elements_dominant?(max_elements, matrix)

    assert actual == expect
  end

  test "elements_dominant?/2 returns false" do
    matrix = %Math.Matrix{rows: 3, columns: 3, data: [[1,2,0],[3,4,1],[7,7,8]]}
    max_elements = [%Math.Element{row: 0,col: 1,val: 2}, %Math.Element{row: 1,col: 1, val: 4}, %Math.Element{row: 2,col: 2, val: 8}]

    expect = false

    actual = Math.elements_dominant?(max_elements, matrix)

    assert actual == expect
  end

end
