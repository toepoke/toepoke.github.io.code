using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace NewCSharpFeatures.Tests {
	
	[TestClass]
	public class CSharp_7_PatternMatching {

		/// <summary>
		/// Illustrates the new pattern matching feature in C# 7, which has nothing to do with regular expressions!
		/// Basically you can do a switch statement on a class type (useful for inheritance)
		/// See Shape.Describe for the magic.
		/// </summary>
		[TestMethod]
		public void Pattern_Matching() {
			// Arrange
			Shape t = new Triangle(3, 4, 5);
			Shape r = new Rectangle(2, 4);
			Shape s = new Square(3);

			// Act - not required

			// Assert
			Assert.AreEqual("I'm a triangle and my dimensions are 3, 4 and 5", t.Describe());
			Assert.AreEqual("I'm a rectangle and my dimensions are 2w x 4h", r.Describe());
			Assert.AreEqual("I'm a rectangle and my dimensions are 3w x 3h", s.Describe());
		}

		abstract class Shape {
			abstract public int NumSides();

			public string Describe() {
				switch (this) {
					case Triangle triangle:
						return $"I'm a triangle and my dimensions are {triangle.A}, {triangle.B} and {triangle.C}";

					case Rectangle rectangle 
						/*HACK: Compiler complains otherwise - gets confused because Square inherits from Rectangle*/ when rectangle.Width != rectangle.Height:
						return $"I'm a rectangle and my dimensions are {rectangle.Width}w x {rectangle.Height}h";

					case Square square:
						return $"I'm a rectangle and my dimensions are {square.Width}w x {square.Height}h";
					
					default:
						throw new System.NotSupportedException($"Not supported {nameof(Shape)}");
				}

			}
		}

		class Triangle: Shape {
			public Triangle(int a, int b, int c) {
				this.A = a;
				this.B = b;
				this.C = c;
			}
			public override int NumSides() {
				return 3;
			}
			public int A { get; set; }
			public int B { get; set; }
			public int C { get; set; }
		}

		class Rectangle: Shape {
			public Rectangle(int width, int height) {
				this.Width = width; 
				this.Height = height;
			}
			public override int NumSides() {
				return 4;
			}
			public int Width { get; set; }
			public int Height { get; set; }
		}

		class Square: Rectangle {
			public Square(int value): base(value, value) {				
			}
			public int Value { 
				get {
					return base.Width;
				} 
				set {
					base.Width = value;
					base.Height = value;
				}
			}

		}

	}

}
