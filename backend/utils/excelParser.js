const ExcelJS = require("exceljs");

const parseExcel = async (fileBuffer) => {
  const workbook = new ExcelJS.Workbook();
  await workbook.xlsx.load(fileBuffer);

  const worksheet = workbook.worksheets[0];
  const students = [];

  worksheet.eachRow((row, rowNumber) => {
    if (rowNumber === 1) return; // Skip header row

    const student = {
      name: row.getCell(1).value,
      email: row.getCell(2).value,
      password: row.getCell(3).value || "defaultPassword123", // Temp password (admin can reset later)
      role: "student",
    };

    students.push(student);
  });

  return students;
};

module.exports = parseExcel;