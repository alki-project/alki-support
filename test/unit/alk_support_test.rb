require 'alki/test'

require 'alki/support'

describe Alki::Support do
  after do
    Object.send :remove_const, :AlkiTest if defined? AlkiTest
  end

  describe :load do
    before do
      $foo_loaded = 1
      @saved_features = $LOADED_FEATURES.dup
    end

    after do
      $LOADED_FEATURES.replace @saved_features
    end

    it 'should require named file' do
      $foo_loaded.must_equal 1
      Alki::Support.load('alki_test/foo')
      $foo_loaded.must_equal 2
    end

    it 'should be return the class in the named file' do
      Alki::Support.load('alki_test/foo').name.must_equal 'AlkiTest::Foo'
    end

    it 'should return nil if the class cant be found' do
      Alki::Support.load('alki_test/bar').must_be_nil
    end

    it 'should raise load error if file cant be found' do
      assert_raises LoadError do
        Alki::Support.load('alki_test/foobar')
      end
    end
  end

  describe :create_constant do
    it 'should create the named constant and assigned the value to it' do
      Alki::Support.create_constant 'AlkiTest::C1', :c1
      AlkiTest::C1.must_equal :c1
    end

    it 'should create intermediate modules as necessary' do
      Alki::Support.create_constant 'AlkiTest::M1::C1', :c1
      AlkiTest::M1::C1.must_equal :c1
    end

    it 'can use a different parent module' do
      m = Module.new
      Alki::Support.create_constant 'AlkiTest::C1', :c1, m
      refute defined?(AlkiTest::C1)
      m::AlkiTest::C1.must_equal :c1
    end
  end

  describe :classify do
    it 'should capitalize words and remove underscores' do
      Alki::Support.classify('my_class_name').must_equal 'MyClassName'
    end

    it 'should convert forward slashes to double colons' do
      Alki::Support.classify('a/b/c').must_equal 'A::B::C'
    end
  end

  describe :constantize do
    it 'should lookup constant based on string name' do
      module AlkiTest
        class Foo
        end
      end
      Alki::Support.constantize('AlkiTest::Foo').must_be_same_as AlkiTest::Foo
    end

    it 'should allow looking constant up with a given root module' do
      m = Module.new do
        module self::AlkiTest
          class Foo
          end
        end
      end
      refute(defined?(AlkiTest::Foo))
      Alki::Support.constantize('AlkiTest::Foo',m).must_be_same_as m::AlkiTest::Foo
    end
  end

  describe :path_name do
    it 'should return basename of path' do
      Alki::Support.path_name('/a/foo.rb').must_equal 'foo'
    end

    it 'should take an optional root to return the name from' do
      Alki::Support.path_name('/a/foo/bar.rb','/a').must_equal 'foo/bar'
    end

    it 'should return nil if path is not in root' do
      Alki::Support.path_name('/a/foo/bar.rb','/b').must_be_nil
    end

    it 'should return nil if path is not a ruby file' do
      Alki::Support.path_name('/a/foo/bar.py').must_be_nil
    end
  end

  describe :find_root do
    it 'should find first parent directory where given block evaluates to true' do
      Alki::Support.find_root fixture_path('lib','alki_test') do |dir|
        File.exist?(File.join(dir,'lib'))
      end.must_equal fixtures_path
    end

    it 'should return nil if never found' do
      Alki::Support.find_root fixture_path('lib','alki_test') do |dir|
        false
      end.must_be_nil
    end
  end
end
