# encoding: utf-8

require 'document_test_helper'

class ColorsTest < DocumentTestCase

  def test_colors_of_file
    engine = OpenStruct.new(variables: { 'variables/colors' => %w(red blue) })
    assert_render_equals <<-INPUT, <<-OUTPUT, {}, engine
      @colors variables/colors
    INPUT
      <ul class="livingstyleguide--color-swatches -lsg-2-columns">
        <li class="livingstyleguide--color-swatch $red">$red</li>
        <li class="livingstyleguide--color-swatch $blue">$blue</li>
      </ul>
    OUTPUT
  end

  def test_defined_colors
    assert_render_equals <<-INPUT, <<-OUTPUT
      @colors {
        $my-orange $my_green
      }
    INPUT
      <ul class="livingstyleguide--color-swatches -lsg-2-columns">
        <li class="livingstyleguide--color-swatch $my-orange">$my-orange</li>
        <li class="livingstyleguide--color-swatch $my-green">$my_green</li>
      </ul>
    OUTPUT
  end

  def test_rows
    assert_render_equals <<-INPUT, <<-OUTPUT
      @colors {
        $pink $purple $gray
        $turquoise $cyan $black
      }
    INPUT
      <ul class="livingstyleguide--color-swatches -lsg-3-columns">
        <li class="livingstyleguide--color-swatch $pink">$pink</li>
        <li class="livingstyleguide--color-swatch $purple">$purple</li>
        <li class="livingstyleguide--color-swatch $gray">$gray</li>
        <li class="livingstyleguide--color-swatch $turquoise">$turquoise</li>
        <li class="livingstyleguide--color-swatch $cyan">$cyan</li>
        <li class="livingstyleguide--color-swatch $black">$black</li>
      </ul>
    OUTPUT
  end

  def test_skipped_cells
    assert_render_equals <<-INPUT, <<-OUTPUT
      @colors {
        $pink $purple
        -     $turquoise
      }
    INPUT
      <ul class="livingstyleguide--color-swatches -lsg-2-columns">
        <li class="livingstyleguide--color-swatch $pink">$pink</li>
        <li class="livingstyleguide--color-swatch $purple">$purple</li>
        <li class="livingstyleguide--color-swatch -lsg-empty">-</li>
        <li class="livingstyleguide--color-swatch $turquoise">$turquoise</li>
      </ul>
    OUTPUT
  end

  def test_functions_and_colors
    assert_render_equals <<-INPUT, <<-OUTPUT
      @scss {
        $pink: #c82570 !global;
      }
      @colors {
        $pink purple() #87c53b red
      }
    INPUT
      <ul class="livingstyleguide--color-swatches -lsg-4-columns">
        <li class="livingstyleguide--color-swatch $pink">$pink</li>
        <li class="livingstyleguide--color-swatch purple()">purple()</li>
        <li class="livingstyleguide--color-swatch #87c53b">#87c53b</li>
        <li class="livingstyleguide--color-swatch red">red</li>
      </ul>
    OUTPUT
    assert_match '.\$pink', @doc.css
    assert_match '.purple\(\)', @doc.css
    assert_match '.\#87c53b', @doc.css
    assert_match '.red', @doc.css
  end

end
