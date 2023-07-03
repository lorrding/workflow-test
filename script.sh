# !/bin/bash

> issues.md

occuringRules=(
    false
    false
    false
    false
    false
)
rules=(
    "viewBox=\"0 0 192 192\""
    "fill=\"none\""
    "stroke=\"black\""
    "stroke-width=\"12\""
    "stroke-linejoin=\"round\""
)
ruleNames=(
    "viewbox"
    "fillValue"
    "strokeColor"
    "strokeWidth"
    "strokeLineJoin"
)
messages=(
    "### **Incorrect viewbox size**. Viewbox should be \`0 0 192 192\` in file(s):"
    "### **Incorrect fill value**. No attribute \`fill\` with value \`none\` was found in file(s):"
    "### **Incorrect stroke color**. Stroke color should be black (\`black\`, \`#000000\`, \`#000\`, \`rgb(0,0,0)\`, or \`rgb(0%,0%,0%)\`) in file(s):"
    "### **Incorrect stroke width**. Standard stroke width should be \`12\`px in file(s):"
    "### **Incorrect stroke linejoin**. Stroke linejoin should be \`round\` in file(s):"
)
tips=(
    ""
    "Icons must be outlined (not filled).
    If your icon does not contain any \`<path>\` (only \`<circle>\` or \`<rect>\`), you can ignore this warning.*"
    ""
    "*Other width can be used but 12 should be the main width*"
    "*If your icon does not contain any \`<path>\` (only \`<circle>\` or \`<rect>\`), you can ignore this warning.*"
)

# for every file in current directory
for file in *.svg; do
    # read file content as xml
    xml=$(cat $file)

    # check if xml follows the rules
    for i in "${!rules[@]}"; do
        # special rule to handle multiple "black" texts
        if [[ "${ruleNames[$i]}" == "strokeColor" ]]; then
            if [[ ! $xml == *"stroke=\"black\""* && ! $xml == *"stroke=\"#000000\""* && ! $xml == *"stroke=\"#000\""* && ! $xml == *"stroke=\"rgb(0,0,0)\""* && ! $xml == *"stroke=\"rgb(0%,0%,0%)\""* ]]; then
                echo "File $file has invalid ${ruleNames[$i]}"
                if [[ ${occuringRules[$i]} == false ]]; then
                    occuringRules[$i]=true
                    echo "${messages[$i]}" >> "${ruleNames[$i]}.md"
                    echo "${tips[$i]}" >> "${ruleNames[$i]}.md"
                fi
                echo "- \`$file\`" >> "${ruleNames[$i]}.md"
            fi
        else
            if [[ ! $xml == *"${rules[$i]}"* ]]; then
                echo "File $file has invalid ${ruleNames[$i]}"
                if [[ ${occuringRules[$i]} == false ]]; then
                    occuringRules[$i]=true
                    echo "${messages[$i]}" >> "${ruleNames[$i]}.md"
                    echo "${tips[$i]}" >> "${ruleNames[$i]}.md"
                fi
                echo "- \`$file\`" >> "${ruleNames[$i]}.md"
            fi
        fi
    done
done

# if any occuringRules is true then add header to issues.md
for i in "${!occuringRules[@]}"; do
    if [[ ${occuringRules[$i]} == true ]]; then
        echo "# Some of the svgs don't conform to the Lawnicon guidelines. Fix the svgs so that reviewers would have less to check and clarify deficiencies." >> issues.md
        break
    fi
done

# for every error file, add it to issues.md
for file in *.md; do
    if [[ $file != "issues.md" ]]; then
        cat $file >> issues.md
        rm $file
    fi
done


if [[ ! -s issues.md ]]; then
    rm issues.md
else
    echo "" >> issues.md
    echo "See [CONTRIBUTING](https://github.com/LawnchairLauncher/lawnicons/blob/develop/.github/CONTRIBUTING.md) guide for more details" >> issues.md
fi