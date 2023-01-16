using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ReactMXHApi6.Migrations
{
    public partial class AddCategoryCulmn : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "Category",
                table: "Posts",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Category",
                table: "Posts");
        }
    }
}
