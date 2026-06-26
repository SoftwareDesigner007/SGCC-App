const fs = require('fs');
const path = require('path');

const screensDir = 'lib/screens';
const filesToUpdate = [
  'home_screen.dart',
  'courses_screen.dart',
  'about_screen.dart',
  'contact_screen.dart',
  'study_material_screen.dart'
];

filesToUpdate.forEach(file => {
  const fullPath = path.join(screensDir, file);
  if (!fs.existsSync(fullPath)) return;

  let content = fs.readFileSync(fullPath, 'utf8');

  // Check if AppFooter is already added
  if (content.includes('AppFooter')) {
    console.log(`Skipping ${file}, AppFooter already exists.`);
    return;
  }

  // 1. Add import statement at the top (after other imports)
  const importStatement = `import '../widgets/app_footer.dart';\n`;
  const lastImportIndex = content.lastIndexOf('import ');
  if (lastImportIndex !== -1) {
    const endOfLastImport = content.indexOf(';', lastImportIndex) + 1;
    content = content.slice(0, endOfLastImport) + '\n' + importStatement + content.slice(endOfLastImport);
  } else {
    content = importStatement + content;
  }

  // 2. Find slivers array and insert the footer at the end
  const sliversIndex = content.indexOf('slivers: [');
  if (sliversIndex === -1) {
    console.log(`Warning: 'slivers: [' not found in ${file}`);
    return;
  }

  let openBrackets = 0;
  let insertIndex = -1;
  const startIndex = sliversIndex + 'slivers: '.length;

  for (let i = startIndex; i < content.length; i++) {
    if (content[i] === '[') {
      openBrackets++;
    } else if (content[i] === ']') {
      openBrackets--;
      if (openBrackets === 0) {
        insertIndex = i;
        break;
      }
    }
  }

  if (insertIndex !== -1) {
    const footerCode = `\n          const SliverToBoxAdapter(child: AppFooter()),\n        `;
    content = content.slice(0, insertIndex) + footerCode + content.slice(insertIndex);
    fs.writeFileSync(fullPath, content, 'utf8');
    console.log(`Updated ${file}`);
  } else {
    console.log(`Error: Could not find matching bracket in ${file}`);
  }
});
console.log('Script completed.');
