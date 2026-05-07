from pydantic import BaseModel
from enum import Enum


class BodyType(str, Enum):
    STRAIGHT = "STRAIGHT"
    NATURAL = "NATURAL"
    WAVE = "WAVE"


class LandmarkPoint(BaseModel):
    x: float
    y: float
    z: float
    visibility: float


class AnalysisResult(BaseModel):
    body_type: BodyType
    confidence: float
    shoulder_width: float
    hip_width: float
    waist_ratio: float
    shoulder_hip_ratio: float
    landmarks: list[LandmarkPoint]
