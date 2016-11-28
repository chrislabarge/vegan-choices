require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  subject { Ingredient.new('Some Name') }

  it { should have_attr_accessor(:name) }
  it { should have_attr_accessor(:and_or) }
  it { should have_attr_accessor(:nested) }
  it { should have_attr_accessor(:description) }

  describe '#initialize' do
    it 'requires a name to intialize' do
      error = nil

      begin
        Ingredient.new
      rescue => e
        error = e
      end

      expect(error.try(:class)).to eq(ArgumentError)
    end
  end

  describe '#nested=' do
    let(:ingredient) { Ingredient.new('Some Name') }
    let(:ingredient_list) { [Ingredient.new('Some Name')] }

    it 'sets the instance variable to passed Array of Ingredients' do
      ingredient.nested = ingredient_list

      expect(ingredient.nested).to eq ingredient_list
    end


    context 'when passed a string' do
      it 'raises an error' do
        error = nil

        begin
          ingredient.nested = 'some string'
        rescue => e
          error = e
        end

        expect(error.try(:class)).to eq(Error::AttributeType)
      end
    end

    context 'when passed an Array of non Ingedient instances' do
      it 'raises an error' do
        list = ingredient_list.push('non Ingredient instance')
        error = nil

        begin
          ingredient.nested = list
        rescue => e
          error = e
        end

        expect(error.try(:class)).to eq(Error::AttributeType)
      end
    end
  end

  describe '#and_or=' do
    let(:ingredient) { Ingredient.new('Some Name') }
    let(:ingredient_with_context) { Ingredient.new('Some Name', context: 'and') }
    let(:ingredient_without_context) { Ingredient.new('Some Name') }

    it 'sets the instance variable to passed Ingredient instance with context' do
      ingredient.and_or = ingredient_with_context

      expect(ingredient.and_or).to eq ingredient_with_context
    end

    context 'when passed a string' do
      it 'raises an error' do
        error = nil

        begin
          ingredient.and_or = 'some string'
        rescue => e
          error = e
        end

        expect(error.try(:class)).to eq(Error::AttributeType)
      end
    end

    context 'when passed an Ingredient without context' do
      it 'raises an error' do
        error = nil

        begin
          ingredient.and_or = ingredient_without_context
        rescue => e
          error = e
        end

        expect(error.try(:class)).to eq(Error::AttributeType)
      end
    end
  end

  describe '#description=' do
    let(:ingredient) { Ingredient.new('Some Name') }
    let(:description) { 'Some Description' }

    it 'sets the instance variable to passed a string' do
      ingredient.description = description

      expect(ingredient.description).to eq description
    end

    context 'when passed a symbol' do
      it 'raises an error' do
        error = nil

        begin
          ingredient.description = :some_description
        rescue => e
          error = e
        end

        expect(error.try(:class)).to eq(Error::AttributeType)
      end
    end
  end

  describe '#context=' do
    let(:ingredient) { Ingredient.new('Some Name') }
    let(:context) { [] }

    it 'sets the instance variable to a string' do
      context = 'and'
      ingredient.context = context

      expect(ingredient.context).to eq context
    end

    context 'when passed a non string' do
      it 'raises an error' do
        context = 5
        error = nil

        begin
          ingredient.context = context
        rescue => e
          error = e
        end

        expect(error.try(:class)).to eq(Error::AttributeType)
      end
    end
  end
end
