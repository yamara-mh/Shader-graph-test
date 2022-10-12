using UnityEngine;
using UnityEngine.Rendering.Universal;

public class DecalCircleShadow : MonoBehaviour
{
    [SerializeField] public DecalProjector Decal;
    [SerializeField] public float RayRadius = 0.5f;
    [SerializeField] public float RayMargin = 0.1f;
    [SerializeField] public Vector3 RayDirection = new Vector3(0f, -1f, 0f);
    [SerializeField] public LayerMask RayMask = int.MaxValue;
    [SerializeField] public bool AlwaysLookRayDicrection = true;
    [SerializeField] public float BaseSizeRate = 1f;
    [SerializeField] public float AddSizeRate = 0.1f;
    [SerializeField, Range(0f, 1f)] public float MinOpacity = 0.1f;
    [SerializeField, Range(0f, 1f)] public float MaxOpacity = 0.9f;
    [SerializeField] public float AddOpacityRate = 0.1f;

    [System.NonSerialized] public Vector2 DefaultDecalScale = Vector2.one;

    private void Start()
    {
        DefaultDecalScale = Decal.size;
    }

    private void LateUpdate()
    {
        if (AlwaysLookRayDicrection) transform.forward = RayDirection;

        if (RayRadius == 0f)
        {
            if (Physics.Raycast(transform.position + -RayDirection * RayMargin, RayDirection, out var hit1, Decal.size.z + RayMargin, RayMask))
            {
                HitProcessing(hit1);
                return;
            }
        }
        else if (Physics.SphereCast(transform.position + -RayDirection * RayRadius * RayMargin, RayRadius, RayDirection, out var hit2, Decal.size.z + RayRadius + RayMargin, RayMask))
        {
            HitProcessing(hit2);
            return;
        }
        Decal.fadeFactor = 0f;
    }

    private void HitProcessing(RaycastHit hit)
    {
        var distance = hit.distance;
        Decal.fadeFactor = Mathf.Clamp(1f - Mathf.Max(0f, distance - RayMargin) * AddOpacityRate, MinOpacity, MaxOpacity);
        var size = DefaultDecalScale * BaseSizeRate + DefaultDecalScale * Mathf.Max(0f, distance - RayMargin) * AddSizeRate;
        Decal.size = new Vector3(size.x, size.y, Decal.size.z);
    }

#if UNITY_EDITOR
    private void OnValidate()
    {
        Decal ??= GetComponent<DecalProjector>();
    }
#endif
}