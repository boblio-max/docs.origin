import os
import sys

def main():
    changes_file = r'C:\Users\smile\OneDrive\Documents\GitHub\origin-dev\origin_web\changes.txt'
    docs_dir = r'C:\Users\smile\OneDrive\Documents\GitHub\docs.origin'
    
    try:
        with open(changes_file, 'r', encoding='utf-8') as f:
            changes = f.read().strip()
    except Exception as e:
        print(f"Error reading changes.txt: {e}")
        return

    if not changes or "No changes detected" in changes:
        print("No changes to apply.")
        return

    print("Detected changes:")
    print(changes)
    
    try:
        from g4f.client import Client
    except ImportError:
        print("g4f package not installed. Cannot apply changes with AI.")
        return

    client = Client()
    
    available_files = [
        'docs.html', 'tutorials.html', 'index.html', 
        'osf.html', 'others.html', 'community.html', 'support.html'
    ]
    
    prompt = (
        "You are an expert documentation manager for the Origin programming language.\n"
        f"The following changes have been made to the origin language:\n{changes}\n\n"
        "Which of the following documentation website files need to be updated to reflect these changes?\n"
        f"Available files: {', '.join(available_files)}\n\n"
        "Respond ONLY with a comma-separated list of file names. If none, respond with 'None'."
    )
    
    print("Determining which files to update...")
    try:
        response = client.chat.completions.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are a helpful assistant."},
                {"role": "user", "content": prompt}
            ]
        )
        files_to_update_str = response.choices[0].message.content.strip()
    except Exception as e:
        print(f"Error querying AI for files: {e}")
        return

    print(f"AI suggested updating: {files_to_update_str}")
    
    if files_to_update_str.lower() == 'none' or not files_to_update_str:
        print("No files to update.")
        return
        
    files_to_update = [f.strip() for f in files_to_update_str.split(',') if f.strip() in available_files]
    
    for file_name in files_to_update:
        file_path = os.path.join(docs_dir, file_name)
        if not os.path.exists(file_path):
            continue
            
        print(f"Updating {file_name}...")
        with open(file_path, 'r', encoding='utf-8') as f:
            current_content = f.read()
            
        update_prompt = (
            "You are an expert web developer and technical writer.\n"
            f"The Origin programming language has been updated:\n{changes}\n\n"
            f"Here is the current HTML content of {file_name}:\n"
            "```html\n"
            f"{current_content}\n"
            "```\n\n"
            "Please carefully update the HTML to reflect the new changes in the Origin language. "
            "Integrate the new syntax, concepts, or fixes naturally into the existing structure. "
            "Output ONLY the complete updated raw HTML content. Do NOT include any markdown code blocks (like ```html), just the raw text."
        )
        
        try:
            res = client.chat.completions.create(
                model="gpt-4",
                messages=[
                    {"role": "system", "content": "You output only exactly the requested raw HTML file without any markdown wrappers."},
                    {"role": "user", "content": update_prompt}
                ]
            )
            new_content = res.choices[0].message.content.strip()
            
            # Safely remove markdown formatting if AI still included it
            if new_content.startswith("```html"):
                new_content = new_content[7:]
            if new_content.startswith("```"):
                new_content = new_content[3:]
            if new_content.endswith("```"):
                new_content = new_content[:-3]
                
            new_content = new_content.strip()
            
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(new_content)
                
            print(f"Successfully updated {file_name}.")
        except Exception as e:
            print(f"Error updating {file_name}: {e}")

if __name__ == "__main__":
    main()