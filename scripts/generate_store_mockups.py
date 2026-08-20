import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

def hex_to_rgb(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

def create_gradient(width, height, top_color, bottom_color):
    base = Image.new('RGBA', (width, height), top_color)
    top_r, top_g, top_b = hex_to_rgb(top_color)
    bot_r, bot_g, bot_b = hex_to_rgb(bottom_color)
    
    # Create smooth gradient array
    grad = Image.new('RGBA', (width, height))
    draw = ImageDraw.Draw(grad)
    for y in range(height):
        ratio = y / float(height)
        r = int(top_r * (1 - ratio) + bot_r * ratio)
        g = int(top_g * (1 - ratio) + bot_g * ratio)
        b = int(top_b * (1 - ratio) + bot_b * ratio)
        draw.line([(0, y), (width, y)], fill=(r, g, b, 255))
    return grad

def add_glow_circles(img, color, cx, cy, radius):
    glow = Image.new('RGBA', img.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(glow)
    r, g, b = hex_to_rgb(color)
    draw.ellipse([cx - radius, cy - radius, cx + radius, cy + radius], fill=(r, g, b, 120))
    glow = glow.filter(ImageFilter.GaussianBlur(radius // 1.5))
    return Image.alpha_composite(img, glow)

def make_rounded_corner_mask(size, radius):
    mask = Image.new('L', size, 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle([0, 0, size[0], size[1]], radius=radius, fill=255)
    return mask

def generate_mockup(raw_screenshot_path, output_path, badge_text, title_text, subtitle_text, theme):
    canvas_w, canvas_h = 1080, 1920
    
    # 1. Background gradient
    canvas = create_gradient(canvas_w, canvas_h, theme['bg_top'], theme['bg_bot'])
    
    # 2. Ambient glow circles
    canvas = add_glow_circles(canvas, theme['accent_1'], 200, 220, 260)
    canvas = add_glow_circles(canvas, theme['accent_2'], 880, 450, 300)
    canvas = add_glow_circles(canvas, theme['accent_1'], 540, 1500, 400)
    
    draw = ImageDraw.Draw(canvas)
    
    # Fonts
    font_bold = '/System/Library/Fonts/Supplemental/Arial Bold.ttf'
    font_reg = '/System/Library/Fonts/Helvetica.ttc'
    
    badge_font = ImageFont.truetype(font_bold, 28)
    title_font = ImageFont.truetype(font_bold, 64)
    sub_font = ImageFont.truetype(font_reg, 32)
    
    # 3. Badge Pill at top
    badge_bbox = badge_font.getbbox(badge_text)
    badge_w = badge_bbox[2] - badge_bbox[0] + 48
    badge_h = badge_bbox[3] - badge_bbox[1] + 24
    badge_x = (canvas_w - badge_w) // 2
    badge_y = 100
    
    # Badge background
    badge_bg = Image.new('RGBA', canvas.size, (0, 0, 0, 0))
    badge_draw = ImageDraw.Draw(badge_bg)
    r1, g1, b1 = hex_to_rgb(theme['accent_1'])
    badge_draw.rounded_rectangle(
        [badge_x, badge_y, badge_x + badge_w, badge_y + badge_h],
        radius=badge_h // 2,
        fill=(r1, g1, b1, 50),
        outline=(r1, g1, b1, 200),
        width=2
    )
    canvas = Image.alpha_composite(canvas, badge_bg)
    draw = ImageDraw.Draw(canvas)
    
    # Badge Text
    text_x = badge_x + 24
    text_y = badge_y + 11
    draw.text((text_x, text_y), badge_text, font=badge_font, fill=hex_to_rgb(theme['accent_1']))
    
    # 4. Main Title
    title_bbox = title_font.getbbox(title_text)
    title_w = title_bbox[2] - title_bbox[0]
    title_x = (canvas_w - title_w) // 2
    title_y = badge_y + badge_h + 26
    
    # Title Shadow + Text
    draw.text((title_x + 2, title_y + 3), title_text, font=title_font, fill=(0, 0, 0, 180))
    draw.text((title_x, title_y), title_text, font=title_font, fill=(255, 255, 255, 255))
    
    # 5. Subtitle
    sub_bbox = sub_font.getbbox(subtitle_text)
    sub_w = sub_bbox[2] - sub_bbox[0]
    sub_x = (canvas_w - sub_w) // 2
    sub_y = title_y + 80
    draw.text((sub_x, sub_y), subtitle_text, font=sub_font, fill=(220, 225, 245, 240))
    
    # 6. Phone Mockup Frame
    raw_img = Image.open(raw_screenshot_path).convert('RGBA')
    # Crop status bar (top 56px) and bottom home indicator (bottom 20px)
    w_raw, h_raw = raw_img.size
    cropped = raw_img.crop((0, 56, w_raw, h_raw - 15))
    
    # Target phone screen dimensions
    screen_w = 680
    screen_h = int(screen_w * (cropped.size[1] / cropped.size[0]))
    # limit screen height to fit comfortably
    if screen_h > 1320:
        screen_h = 1320
        screen_w = int(screen_h * (cropped.size[0] / cropped.size[1]))
        
    screen_resized = cropped.resize((screen_w, screen_h), Image.Resampling.LANCZOS)
    
    # Rounded corners for screen
    screen_radius = 42
    screen_mask = make_rounded_corner_mask((screen_w, screen_h), screen_radius)
    
    # Phone Bezel
    bezel_padding = 16
    phone_w = screen_w + (bezel_padding * 2)
    phone_h = screen_h + (bezel_padding * 2)
    phone_x = (canvas_w - phone_w) // 2
    phone_y = sub_y + 70
    phone_radius = screen_radius + bezel_padding
    
    # 7. 3D Floating Drop Shadow for phone
    shadow = Image.new('RGBA', canvas.size, (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow)
    shadow_draw.rounded_rectangle(
        [phone_x, phone_y + 20, phone_x + phone_w, phone_y + phone_h + 20],
        radius=phone_radius,
        fill=(0, 0, 0, 160)
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(30))
    canvas = Image.alpha_composite(canvas, shadow)
    
    # Draw Phone Bezel
    phone_layer = Image.new('RGBA', canvas.size, (0, 0, 0, 0))
    phone_draw = ImageDraw.Draw(phone_layer)
    
    # Outer Bezel Body
    phone_draw.rounded_rectangle(
        [phone_x, phone_y, phone_x + phone_w, phone_y + phone_h],
        radius=phone_radius,
        fill=(22, 24, 38, 255),
        outline=(60, 65, 95, 255),
        width=3
    )
    
    # Inner Rim highlight
    phone_draw.rounded_rectangle(
        [phone_x + 4, phone_y + 4, phone_x + phone_w - 4, phone_y + phone_h - 4],
        radius=phone_radius - 4,
        outline=(110, 115, 155, 120),
        width=1
    )
    
    canvas = Image.alpha_composite(canvas, phone_layer)
    
    # Paste the game screen inside bezel
    canvas.paste(screen_resized, (phone_x + bezel_padding, phone_y + bezel_padding), screen_mask)
    
    # Save final image
    canvas.convert('RGB').save(output_path, 'PNG', quality=95)
    print(f"Saved: {output_path}")

screenshots = [
    {
        'file': '/Users/boradhruvajyoti/.gemini/antigravity-ide/brain/63b797ad-ae50-4e0d-b380-6ff56c6fd806/.user_uploaded/media_1787236927017.png',
        'out': 'assets/store/screenshot_1_word_search.png',
        'badge': '100+ PUZZLE LEVELS',
        'title': 'WORD SEARCH',
        'sub': 'Find Hidden Words & Beat The Clock',
        'theme': {
            'bg_top': '#1C1238',
            'bg_bot': '#0B0818',
            'accent_1': '#6C63FF',
            'accent_2': '#00C9A7',
        }
    },
    {
        'file': '/Users/boradhruvajyoti/.gemini/antigravity-ide/brain/63b797ad-ae50-4e0d-b380-6ff56c6fd806/.user_uploaded/media_1787236904112.png',
        'out': 'assets/store/screenshot_2_sudoku.png',
        'badge': 'PROGRESSIVE DIFFICULTY',
        'title': 'CLASSIC SUDOKU',
        'sub': 'Train Your Logic & Sharpen Your Focus',
        'theme': {
            'bg_top': '#0E1D3B',
            'bg_bot': '#060B18',
            'accent_1': '#3A86FF',
            'accent_2': '#00C9A7',
        }
    },
    {
        'file': '/Users/boradhruvajyoti/.gemini/antigravity-ide/brain/63b797ad-ae50-4e0d-b380-6ff56c6fd806/.user_uploaded/media_1787236933550.png',
        'out': 'assets/store/screenshot_3_cryptogram.png',
        'badge': 'BRAIN TEASING CIPHERS',
        'title': 'CRYPTOGRAM',
        'sub': 'Decode Famous Quotes & Hidden Secrets',
        'theme': {
            'bg_top': '#260F38',
            'bg_bot': '#0D0616',
            'accent_1': '#8338EC',
            'accent_2': '#FF006E',
        }
    },
    {
        'file': '/Users/boradhruvajyoti/.gemini/antigravity-ide/brain/63b797ad-ae50-4e0d-b380-6ff56c6fd806/.user_uploaded/media_1787236949890.png',
        'out': 'assets/store/screenshot_4_quadsum.png',
        'badge': 'FAST-PACED MATH PUZZLE',
        'title': 'QUADSUM LOGIC',
        'sub': 'Place Digits 1–9 & Match Target Sums',
        'theme': {
            'bg_top': '#0B2736',
            'bg_bot': '#050F18',
            'accent_1': '#00B4D8',
            'accent_2': '#06D6A0',
        }
    }
]

os.makedirs('assets/store', exist_ok=True)
for item in screenshots:
    generate_mockup(item['file'], item['out'], item['badge'], item['title'], item['sub'], item['theme'])
