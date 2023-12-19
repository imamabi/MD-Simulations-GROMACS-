
def delete_secondary_structure_for_residues(input_file, output_file, residues_to_delete):
    with open(input_file, 'r') as infile:
        lines = infile.readlines()

    modified_lines = []
    found_y_axis_labels = False

    for line in lines:
        if found_y_axis_labels:
            # Parse the line to get residue ID and secondary structure
            parts = line.strip().split()
            if len(parts) >= 2:
                residue_id = int(parts[0])
                secondary_structure = parts[1]

                # Check if the residue should be deleted
                if residue_id not in residues_to_delete:
                    modified_lines.append(line)
        else:
            modified_lines.append(line)
            if line.strip() == '  "  0" "  1" "  2" "  3" "  4"':
                found_y_axis_labels = True

    with open(output_file, 'w') as outfile:
        outfile.writelines(modified_lines)

# Specify the input and output file paths
input_file = 'input.xpm'
output_file = 'output.xpm'

# Specify the residue IDs you want to delete
residues_to_delete = [5, 10, 15]  # Replace with the IDs you want to delete

# Call the function to delete secondary structure for specific residues
delete_secondary_structure_for_residues(input_file, output_file, residues_to_delete)
