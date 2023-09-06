const fs = require('fs');
const path = require('path');

const rules = [
    {
        name: "viewBox",
        rule: "viewBox=\"0 0 192 192\"",
        error: "Incorrect viewbox size",
        description: "Viewbox should be \`0 0 192 192\`",
        protip: null
    },
    {
        name: "fillValue",
        rule: "fill=\"none\"",
        error: "Incorrect fill value",
        description: "Fill should be set to \`none\` and be outlined",
        protip: "If your icon does not contain any \`<path>\` (only \`<circle>\` or \`<rect>\`), you can ignore this warning"
    },
    {
        name: "strokeColor",
        rule: [
            "stroke=\"black\"",
            "stroke=\"#000000\"",
            "stroke=\"#000\"",
            "stroke=\"rgb(0,0,0)\"",
            "stroke=\"rgb(0%,0%,0%)\""
        ],
        error: "Incorrect stroke value",
        description: "Stroke should be set to **black** *(\`black\`, \`#000000\`, \`#000\`, \`rgb(0,0,0)\`, or \`rgb(0%,0%,0%)\`)*",
        protip: null
    },
    {
        name: "strokeWidth",
        rule: "stroke-width=\"12\"",
        error: "Incorrect stroke-width value",
        description: "Standard stroke width should be \`12\`px",
        protip: "Other width can be used for finer details but 12 should be the main width"
    },
    {
        name: "strokeLinejoin",
        rule: "stroke-linejoin=\"round\"",
        error: "Incorrect stroke-linejoin value",
        description: "Stroke-linejoin should be set to \`round\`",
        protip: "If your icon does not contain any \`<path>\` (only \`<circle>\` or \`<rect>\`), you can ignore this warning"
    }
];

// Your validation logic here
function validateSvg(file) {
    let hasError = false;
    let errors = [];


    try {
        const svg = fs.readFileSync(file, 'utf8');

        rules.forEach(rule => {
            rule.rule = Array.isArray(rule.rule)? rule.rule : [rule.rule];
            const isValid = rule.rule.some(r => svg.includes(r));
            if (!isValid) {
                hasError = true;
                errors.push(`- **${rule.error}**. ${rule.description}.\n`);
                if (rule.protip) {
                    errors.push(`*${rule.protip}.*`);
                }
            }
        });
    } catch (err) {
        console.log(`File ${file} does not exist or is not readable`);
        process.exit(0);
    }

    return hasError? errors : [];
}

const file = process.argv[2];
if (!file) {
    console.log('No file path provided');
    process.exit(0);
}

const errors = validateSvg(file);

if (errors.length > 0) {
    const errorFile = path.join(process.cwd(), 'errors.md');
    try {
        fs.appendFileSync(errorFile, `# ${file}:\n${errors.join('\n')}\n`);
    } catch (err) {
        console.log(`Error while writing errors to ${errorFile}`);
    }
}
