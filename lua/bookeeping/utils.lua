local Utils = {}
function Utils.get_note_text(notes)
    local lines = {}
    for _, note in ipairs(notes) do
        table.insert(lines, note.date)
        for _, line in pairs(note.lines) do
            table.insert(lines, line)
        end
        table.insert(lines, '')
    end
    return lines
end

return Utils
