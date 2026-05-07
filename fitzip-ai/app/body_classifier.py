import math
from app.schemas import BodyType


def _distance(p1, p2) -> float:
    return math.sqrt((p1.x - p2.x) ** 2 + (p1.y - p2.y) ** 2)


def classify_body_type(landmarks) -> tuple[BodyType, float, dict]:
    """
    MediaPipe Pose 랜드마크 기반 체형 분류.

    사용 랜드마크 인덱스 (MediaPipe 기준):
      11: 왼쪽 어깨, 12: 오른쪽 어깨
      23: 왼쪽 엉덩이, 24: 오른쪽 엉덩이
      어깨 중점과 엉덩이 중점 사이 → 허리 추정
    """
    left_shoulder = landmarks[11]
    right_shoulder = landmarks[12]
    left_hip = landmarks[23]
    right_hip = landmarks[24]

    shoulder_width = _distance(left_shoulder, right_shoulder)
    hip_width = _distance(left_hip, right_hip)

    # 허리 너비: 어깨~엉덩이 중간 지점 추정 (0.4 지점)
    waist_x_left = left_shoulder.x + (left_hip.x - left_shoulder.x) * 0.45
    waist_y_left = left_shoulder.y + (left_hip.y - left_shoulder.y) * 0.45
    waist_x_right = right_shoulder.x + (right_hip.x - right_shoulder.x) * 0.45
    waist_y_right = right_shoulder.y + (right_hip.y - right_shoulder.y) * 0.45

    class _P:
        def __init__(self, x, y):
            self.x = x
            self.y = y

    waist_width = _distance(_P(waist_x_left, waist_y_left), _P(waist_x_right, waist_y_right))

    shoulder_hip_ratio = shoulder_width / hip_width if hip_width > 0 else 1.0
    waist_ratio = waist_width / shoulder_width if shoulder_width > 0 else 1.0

    measurements = {
        "shoulder_width": round(shoulder_width, 4),
        "hip_width": round(hip_width, 4),
        "waist_ratio": round(waist_ratio, 4),
        "shoulder_hip_ratio": round(shoulder_hip_ratio, 4),
    }

    # ── 체형 분류 규칙 ──────────────────────────────────────
    # STRAIGHT : 어깨≈힙(0.9~1.1), 허리 굴곡 적음(waist_ratio > 0.82)
    # NATURAL  : 어깨>힙(1.05~1.25), 균형잡힌 비율
    # WAVE     : 허리 굴곡 뚜렷(waist_ratio < 0.78) 또는 힙≥어깨

    if waist_ratio > 0.82 and 0.90 <= shoulder_hip_ratio <= 1.10:
        body_type = BodyType.STRAIGHT
        confidence = min(1.0, (waist_ratio - 0.82) * 5 + (1.0 - abs(shoulder_hip_ratio - 1.0) * 5))
    elif waist_ratio < 0.78 or shoulder_hip_ratio < 0.92:
        body_type = BodyType.WAVE
        confidence = min(1.0, (0.78 - waist_ratio) * 6 + 0.6)
    else:
        body_type = BodyType.NATURAL
        confidence = 0.75

    return body_type, round(max(0.5, min(1.0, confidence)), 3), measurements
